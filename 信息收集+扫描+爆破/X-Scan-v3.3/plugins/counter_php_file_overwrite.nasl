#
# (C) Tenable Network Security
#
# Ref: http://www.securitytracker.com/alerts/2003/Mar/1006368.html


include("compat.inc");


if (description)
{
 script_id(11611);
 script_version ("$Revision: 1.9 $");
 script_xref(name:"OSVDB", value:"50626");

 script_name(english:"PHP Topsites counter.php count_log_file Parameter Arbitrary File Overwrite");
 script_summary(english:"Determine if counter.php is present");

 script_set_attribute(
   attribute:"synopsis",
   value:string(
     "A web application running on the remote host has a file overwrite\n",
     "vulnerability."
   )
 );
 script_set_attribute(
   attribute:"description", 
   value:string(
      "The remote host has the cgi 'counter.php' installed.\n",
      "\n",
      "This CGI contains a flaw which can be abused by an attacker to\n",
      "overwrite arbitrary files on the system with the privileges of the\n",
      "web server."
   )
 );
 script_set_attribute(
   attribute:"solution", 
   value:"Remove this CGI from the web server."
 );
 script_set_attribute(
   attribute:"cvss_vector", 
   value:"CVSS2#AV:N/AC:L/Au:N/C:N/I:P/A:N"
 );
 script_end_attributes();

 script_category(ACT_GATHER_INFO);
 script_family(english:"CGI abuses");

 script_copyright(english:"This script is Copyright (C) 2003-2008 Tenable Network Security, Inc.");

 script_dependencie("find_service1.nasl", "http_version.nasl");
 script_require_ports("Services/www", 80);
 script_exclude_keys("Settings/disable_cgi_scanning");
 exit(0);
}

include("global_settings.inc");
include("misc_func.inc");
include("http.inc");

port = get_http_port(default:80);
if(!can_host_php(port:port)) exit(0);

dir = make_list(cgi_dirs());

foreach d (dir)
{
 url = string(d, '/counter.php?count_log_file=/nessus');
 buf = http_send_recv3(method:"GET", item:url, port:port);
 if( isnull(buf) ) exit(0);

 if(ereg(pattern:"^HTTP/[0-9]\.[0-9] 200 ", string:buf[2]) &&
    "file(/nessus)" >< buf[2])
   {
    security_warning(port);
    exit(0);
   }
}
