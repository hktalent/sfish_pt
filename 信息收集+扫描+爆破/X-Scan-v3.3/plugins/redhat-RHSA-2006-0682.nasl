
#
# (C) Tenable Network Security
#
# The text of this plugin is (C) Red Hat Inc.
#

include("compat.inc");
if ( ! defined_func("bn_random") ) exit(0);

if(description)
{
 script_id(22444);
 script_version ("$Revision: 1.5 $");
 script_name(english: "RHSA-2006-0682: php");
 script_set_attribute(attribute: "synopsis", value: 
"The remote host is missing the patch for the advisory RHSA-2006-0682");
 script_set_attribute(attribute: "description", value: '
  Updated PHP packages that fix multiple security issues are now available
  for Red Hat Enterprise Linux 2.1.

  This update has been rated as having moderate security impact by the Red
  Hat Security Response Team.

  PHP is an HTML-embedded scripting language commonly used with the Apache
  HTTP Web server.

  A response-splitting issue was discovered in the PHP session handling. If
  a remote attacker can force a carefully crafted session identifier to be
  used, a cross-site-scripting or response-splitting attack could be
  possible. (CVE-2006-3016)

  A buffer overflow was discovered found in the PHP sscanf() function. If a
  script used the sscanf() function with positional arguments in the format
  string, a remote attacker sending a carefully crafted request could execute
  arbitrary code as the \'apache\' user. (CVE-2006-4020)

  An integer overflow was discovered in the PHP wordwrap() and str_repeat()
  functions. If a script running on a 64-bit server used either of these
  functions on untrusted user data, a remote attacker sending a carefully
  crafted request might be able to cause a heap overflow. (CVE-2006-4482)

  An integer overflow was discovered in the PHP memory allocation handling.
  On 64-bit platforms, the "memory_limit" setting was not enforced correctly,
  which could allow a denial of service attack by a remote user.
  (CVE-2006-4486)

  Users of PHP should upgrade to these updated packages which contain
  backported patches to correct these issues. These packages also contain a
  fix for a bug where certain input strings to the metaphone() function could
  cause memory corruption.


');
 script_set_attribute(attribute: "cvss_vector", value: "CVSS2#AV:N/AC:M/Au:N/C:C/I:C/A:C");
script_set_attribute(attribute: "see_also", value: "http://rhn.redhat.com/errata/RHSA-2006-0682.html");
script_set_attribute(attribute: "solution", value: "Get the newest RedHat Updates.");
script_end_attributes();

script_cve_id("CVE-2006-3016", "CVE-2006-4020", "CVE-2006-4482", "CVE-2006-4486");
script_summary(english: "Check for the version of the php packages");
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security");
 script_family(english: "Red Hat Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 
 script_require_keys("Host/RedHat/rpm-list");
 exit(0);
}

include("rpm.inc");

if ( ! get_kb_item("Host/RedHat/rpm-list") ) exit(1, "Could not get the list of packages");

if ( rpm_check( reference:"php-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-devel-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-imap-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-ldap-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-manual-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-mysql-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-odbc-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
if ( rpm_check( reference:"php-pgsql-4.1.2-2.11", release:'RHEL2.1') )
{
 security_hole(port:0, extra:rpm_report_get());
 exit(0);
}
exit(0, "Host if not affected");
