#
# (C) Tenable Network Security
#
#

if ( ! defined_func("bn_random") ) exit(0);
include("compat.inc");

if(description)
{
 script_id(23248);
 script_version("$Revision: 1.7 $");

 script_name(english: "Solaris 5.7 (sparc) : 112536-06");
 script_set_attribute(attribute: "synopsis", value:
"The remote host is missing Sun Security Patch number 112536-06");
 script_set_attribute(attribute: "description", value:
'SEAM 1.0 Jumbo patch for Solaris 2.7.
Date this patch was last updated by Sun : Oct/03/05');
 script_set_attribute(attribute: "solution", value:
"You should install this patch for your system to be up-to-date.");
 script_set_attribute(attribute: "see_also", value:
"http://sunsolve.sun.com/search/document.do?assetkey=1-21-112536-06-1");
 script_set_attribute(attribute: "risk_factor", value: "Medium");
 script_end_attributes();

 script_summary(english: "Check for patch 112536-06");
 script_category(ACT_GATHER_INFO);
 script_copyright(english:"This script is Copyright (C) 2009 Tenable Network Security");
 family["english"] = "Solaris Local Security Checks";
 script_family(english:family["english"]);
 
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/Solaris/showrev");
 exit(0);
}



include("solaris.inc");

e +=  solaris_check_patch(release:"5.7", arch:"sparc", patch:"112536-06", obsoleted_by:"", package:"SUNWkrgdo", version:"5.7.0,REV=1999.06.22.12.10");
e +=  solaris_check_patch(release:"5.7", arch:"sparc", patch:"112536-06", obsoleted_by:"", package:"SUNWkrggl", version:"5.7.0,REV=1999.06.22.12.10");
if ( e < 0 ) { 
	if ( NASL_LEVEL < 3000 ) 
	   security_warning(0);
	else  
	   security_warning(port:0, extra:solaris_get_report());
	exit(0); 
} 
exit(0, "Host is not affected");
