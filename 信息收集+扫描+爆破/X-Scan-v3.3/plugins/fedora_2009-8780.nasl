
#
# (C) Tenable Network Security, Inc.
#
# This plugin text was extracted from Fedora Security Advisory 2009-8780
#

include("compat.inc");

if ( ! defined_func("bn_random") ) exit(0);
if(description)
{
 script_id(40864);
 script_version ("$Revision: 1.2 $");
script_name(english: "Fedora 11 2009-8780: fetchmail");
 script_set_attribute(attribute: "synopsis", value: 
"The remote host is missing the patch for the advisory FEDORA-2009-8780 (fetchmail)");
 script_set_attribute(attribute: "description", value: "Fetchmail is a remote mail retrieval and forwarding utility intended
for use over on-demand TCP/IP links, like SLIP or PPP connections.
Fetchmail supports every remote-mail protocol currently in use on the
Internet (POP2, POP3, RPOP, APOP, KPOP, all IMAPs, ESMTP ETRN, IPv6,
and IPSEC) for retrieval. Then Fetchmail forwards the mail through
SMTP so you can read it through your favorite mail client.

Install fetchmail if you need to retrieve mail over SLIP or PPP
connections.

-
Update Information:

If fetchmail is running in daemon mode, it must be restarted for this update to
take effect (use the 'fetchmail --quit' command to stop the fetchmail process).
");
 script_set_attribute(attribute: "cvss_vector", value: "CVSS2#AV:N/AC:L/Au:N/C:P/I:P/A:N");
script_set_attribute(attribute: "solution", value: "Get the newest Fedora Updates");
script_end_attributes();

 script_cve_id("CVE-2009-2666");
script_summary(english: "Check for the version of the fetchmail package");
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security, Inc.");
 script_family(english: "Fedora Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/RedHat/rpm-list");
 exit(0);
}

include("rpm.inc");

if ( rpm_check( reference:"fetchmail-6.3.9-5.fc11", release:"FC11") )
{
 security_warning(port:0, extra:rpm_report_get());
 exit(0);
}
exit(0, "Host is not affected");
