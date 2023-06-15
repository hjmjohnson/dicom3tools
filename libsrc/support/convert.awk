#  convert.awk Copyright (c) 1993-2022, David A. Clunie DBA PixelMed Publishing. All rights reserved.
# create a C++ header file to read keywords & make dicom attributes
# according to a description in the input template file

# goes to great effort to make sure things are read
#	- in order
#	- once
# so that theoretically the C++ routine could read from standard input
# (assuming of course that the template file is in ascending block
# and offset order)

# can set these values on the command line:
#
#	role	  - "dicom"           - function to extract dicom tags
#		  - "headerpart"      - header part class declarations
#		  - "wholeheader"     - header whole class declarations
#		  - "constructheader" - header whole class constructor
#	prefix
#	offsetwarning=off
#	headerclassparameters=",..."
#		eg. headerclassparameters=",GEN_FileStructureInformation &fileinfo"

function hextodec(hex) {
		gsub("x","0",hex);
		gsub("X","0",hex);
		n=length(hex);
		dec=0;
		i=1;
		while (i <= n) {
			digit=substr(hex,i,1);
			if (digit == "a") digit=10;
			else if (digit == "b") digit=11;
			else if (digit == "c") digit=12;
			else if (digit == "d") digit=13;
			else if (digit == "e") digit=14;
			else if (digit == "f") digit=15;
			else if (index("0123456789",digit) == 0) break;
			dec=dec*16+digit;
			++i;
		}
		return dec;
}

function octtodec(oct) {
		n=length(oct);
		dec=0;
		i=1;
		while (i <= n) {
			digit=substr(oct,i,1);
			if (index("01234567",digit) == 0) break;
			dec=dec*8+digit;
			++i;
		}
		return dec;
}

function anytodec(any) {
		if (substr(any,1,1) == "0") {
			if (substr(any,2,1) == "x" || substr(any,2,1) == "X")
				return hextodec(any)
			else
				return octtodec(any)
		}
		else
			return any
}

NR==1	{

	if (prefix == "" ) prefix="Proprietary"

	if (dicomfunctionname             == "" ) dicomfunctionname	        = "ToDicom_Template"
	if (dumpcommonfunctionname        == "" ) dumpcommonfunctionname        = "DumpCommon"
	if (dumpselectedimagefunctionname == "" ) dumpselectedimagefunctionname = "DumpSelectedImage"
	if (conditionprefix               == "" ) conditionprefix	        = prefix
	if (headeroffsetprefix            == "" ) headeroffsetprefix	        = prefix "Offset"
	if (headeroffsetsuffix            == "" ) headeroffsetsuffix	        = "ptr"
	if (headerclassprefix             == "" ) headerclassprefix	        = prefix "HeaderClass"
	if (headerdicomclassprefix        == "" ) headerdicomclassprefix        = prefix "Header_BothClass"
	if (headerdumpclassprefix         == "" ) headerdumpclassprefix	        = prefix "Header_BothClass"
	if (headerinstanceprefix          == "" ) headerinstanceprefix          = prefix "HeaderInstance"
	if (methodnameprefix              == "" ) methodnameprefix              = prefix "Method"
	if (methodconstructorargsprefix   == "" ) methodconstructorargsprefix   = prefix "MethodConstructorArgs"

	print "// Automatically generated from template - EDITS WILL BE LOST"
	print "//"
	print "// Generated by convert.awk with options or defaults ..."
	print "//"
	print "// \t role=" role
	print "// \t prefix=" prefix
	print "// \t dicomfunctionname=" dicomfunctionname
	print "// \t dumpcommonfunctionname=" dumpcommonfunctionname
	print "// \t dumpselectedimagefunctionname=" dumpselectedimagefunctionname
	print "// \t headeroffsetprefix=" headeroffsetprefix
	print "// \t headeroffsetsuffix=" headeroffsetsuffix
	print "// \t headerclassprefix=" headerclassprefix
	print "// \t headerdicomclassprefix=" headerdicomclassprefix
	print "// \t headerdumpclassprefix=" headerdumpclassprefix
	print "// \t headerinstanceprefix=" headerinstanceprefix
	print "// \t methodnameprefix=" methodnameprefix
	print "// \t methodconstructorargsprefix=" methodconstructorargsprefix
	print "// \t headerclassparameters=" headerclassparameters
	print ""

	if (role == "dicom") {
		print "void "
		print headerdicomclassprefix "::" dicomfunctionname "(AttributeList *list,unsigned imagenumber)"
		print "{"
		print "\t(void)imagenumber;"
		print ""
	}
	if (role == "dump") {
		print "void "
		print headerdumpclassprefix "::" dumpcommonfunctionname "(TextOutputStream *log)"
		print "{"
	}
	if (role == "wholeheader") {
		print "class " headerclassprefix
		print "{"
		print "public:"
		print "\t" headerclassprefix "(istream *ist" headerclassparameters ");"
		print ""
	}
	if (role == "constructheader") {
		print headerclassprefix "::" headerclassprefix "(istream *ist" headerclassparameters ")"
		print "{"
	}

	accumulatedoffset=0
	lastblock=""
	lastmethod=""
	selectimagedone=""
	reservedfieldcount=0
}

/^block/{
	block=""
	if (match($0,"block=\"[^\"]*\""))
		block=substr($0,RSTART+length("block=\""),
			RLENGTH-length("block=\"")-1);
	condition=""
	if (match($0,"condition=\"[^\"]*\""))
		condition=substr($0,RSTART+length("condition=\""),
			RLENGTH-length("condition=\"")-1);
	select=""
	if (match($0,"select=\"[^\"]*\""))
		select=substr($0,RSTART+length("select=\""),
			RLENGTH-length("select=\"")-1);
	method=""
	if (match($0,"method=\"[^\"]*\""))
		method=substr($0,RSTART+length("method=\""),
			RLENGTH-length("method=\"")-1);
	offset=""
	if (match($0,"offset=\"[^\"]*\""))
		offset=anytodec(substr($0,RSTART+length("offset=\""),
			RLENGTH-length("offset=\"")-1));
	intype=""
	if (match($0,"intype=\"[^\"]*\""))
		intype=substr($0,RSTART+length("intype=\""),
			RLENGTH-length("intype=\"")-1);
	inlength=""
	if (match($0,"inlength=\"[^\"]*\""))
		inlength=anytodec(substr($0,RSTART+length("inlength=\""),
			RLENGTH-length("inlength=\"")-1));
	keyword=""
	if (match($0,"keyword=\"[^\"]*\""))
		keyword=substr($0,RSTART+length("keyword=\""),
			RLENGTH-length("keyword=\"")-1);
	name=""
	if (match($0,"name=\"[^\"]*\""))
		name=substr($0,RSTART+length("name=\""),
			RLENGTH-length("name=\"")-1);
	dicomtype=""
	if (match($0,"dicomtype=\"[^\"]*\""))
		dicomtype=substr($0,RSTART+length("dicomtype=\""),
			RLENGTH-length("dicomtype=\"")-1);
	dicomtag=""
	if (match($0,"dicomtag=\"[^\"]*\""))
		dicomtag=substr($0,RSTART+length("dicomtag=\""),
			RLENGTH-length("dicomtag=\"")-1);
	enum=""
	if (match($0,"enum=\"[^\"]*\""))
		enum=substr($0,RSTART+length("enum=\""),
			RLENGTH-length("enum=\"")-1);
	bitmap=""
	if (match($0,"bitmap=\"[^\"]*\""))
		bitmap=substr($0,RSTART+length("bitmap=\""),
			RLENGTH-length("bitmap=\"")-1);
	comment=""
	if (match($0,"#.*$"))
		comment=substr($0,RSTART+length("#"),
			RLENGTH-length("#"));

	ok="yes";

	if (block == "" || block == "?" ) {
		print "Line " FNR ": error - no block" >"/dev/tty"
		ok="no";
	}

	if (select != "image" && select != "") {
		print "Line " FNR ": select may only have value of image" >"/dev/tty"
		ok="no";
	}

	if (method == "" || method == "?") {
		if (lastmethod != "" || lastmethod == "?") {
			print "Line " FNR ": error - must use only method or offset/intype throughout block" >"/dev/tty"
			ok="no";
		}
		if (offset == "" || offset == "?") {
			print "Line " FNR ": error - no offset or method" >"/dev/tty"
			ok="no";
		}
		if (intype == "" || intype == "?") {
			print "Line " FNR ": error - no intype or method" >"/dev/tty"
			ok="no";
		}
		usemethod="no";
	}
	else {
		if ((offset != "" && offset != "?") || (intype != "" && intype != "?")) {
			print "Line " FNR ": error - if method can't have offset or intype" >"/dev/tty"
			ok="no";
		}
		usemethod="yes";
		methodname=methodnameprefix "_" method;
	}
	lastmethod=method;

	if (condition == "")
		conditiontest=""
	else
		conditiontest="if (" conditionprefix condition ") "

	if (block != lastblock) {
		blockclassname=headerclassprefix "_" block
		blockinstancename=headerinstanceprefix "_" block
		if (usemethod == "no") {
			offsetname=headeroffsetprefix "_" block "_" headeroffsetsuffix
		}
		else {
			offsetname="\"" block "\""
		}
		if (role == "headerpart") {
			if (lastblock != "" && lastmethod == "") {
				print "};"
				print ""
			}
			if (usemethod == "no") {
				print "class " blockclassname " {"
				print "public:"
				print "\t"   blockclassname "(istream *ist,long offset)"
				print "\t\t { ReadProprietaryHeader(ist,offset,sizeof *this,(char *)this); }"
				print ""
			}
		}
		if (role == "wholeheader") {
			print "\t" blockclassname " *" blockinstancename ";"
		}
		if (role == "constructheader") {
			print "\t" blockinstancename " = 0;"
			print "\t" conditiontest blockinstancename " = new"
			if (usemethod == "no") {
				print "\t\t" blockclassname "(ist," offsetname ");"
			}
			else {
				# note the space preceeding the methodconstructorargsprefix
				# (which may be null, but if not will have leading comma)
				print "\t\t" blockclassname "(ist " methodconstructorargsprefix "_" block ");"
			}
			print ""
		}
		if (select == "image") {
			if (selectimagedone == "yes") {
				print "Line " FNR ": error - select by image can only be used in one (the last) block" >"/dev/tty"
				ok="no";
			}
			else {
				selectimagedone="yes"
				if (role == "dump") {
					print "}"
					print ""
					print "void "
					print headerdumpclassprefix "::" dumpselectedimagefunctionname "(TextOutputStream *log,unsigned imagenumber)"
					print "{"
				}
			}
		}
		lastblock=""
	}

	if (role == "dicom") {
		if (dicomtype != "" && dicomtype != "?") {
			if      (dicomtype == "AE") { dicomtypedesc="ApplicationEntity" ; }
			else if (dicomtype == "AS") { dicomtypedesc="AgeString"         ; }
			else if (dicomtype == "AT") { dicomtypedesc="AttributeTag"      ; }
			else if (dicomtype == "CS") { dicomtypedesc="CodeString"        ; }
			else if (dicomtype == "DA") { dicomtypedesc="DateString"        ; }
			else if (dicomtype == "DS") { dicomtypedesc="DecimalString"     ; }
			else if (dicomtype == "DT") { dicomtypedesc="DateTimeString"    ; }
			else if (dicomtype == "IS") { dicomtypedesc="IntegerString"     ; }
			else if (dicomtype == "LO") { dicomtypedesc="LongString"        ; }
			else if (dicomtype == "LT") { dicomtypedesc="LongText"          ; }
			else if (dicomtype == "OB") { dicomtypedesc="OtherByteString"   ; }
			else if (dicomtype == "OW") { dicomtypedesc="OtherWordString"   ; }
			else if (dicomtype == "PN") { dicomtypedesc="PersonName"        ; }
			else if (dicomtype == "SH") { dicomtypedesc="ShortString"       ; }
			else if (dicomtype == "SL") { dicomtypedesc="SignedLong"        ; }
			else if (dicomtype == "SS") { dicomtypedesc="SignedShort"       ; }
			else if (dicomtype == "ST") { dicomtypedesc="ShortText"         ; }
			else if (dicomtype == "TM") { dicomtypedesc="TimeString"        ; }
			else if (dicomtype == "UI") { dicomtypedesc="UIString"          ; }
			else if (dicomtype == "UL") { dicomtypedesc="UnsignedLong"      ; }
			else if (dicomtype == "US") { dicomtypedesc="UnsignedShort"     ; }
			else if (dicomtype == "XS") { dicomtypedesc="UnspecifiedShort"  ; }
			else if (dicomtype == "XL") { dicomtypedesc="UnspecifiedLong"   ; }
			else {
				print "Line " FNR ": error in dicomtype - bad type <" \
					dicomtype ">" >"/dev/tty"
				ok="no";
			}
			putdicom="yes"
		}
		else {
			putdicom="no"
		}
	}

	if (usemethod == "no" && (role == "headerpart" || role == "dicom" || role == "dump")) {
		if      (intype == "String"   )           { structtype="String";              sizeoftype=1; fromtype="String";   array="yes"; }
		else if (intype == "Uint8"    )           { structtype="Uint8_8";             sizeoftype=1; fromtype="Unsigned"; array="no";  }
		else if (intype == "Uint16_L" )           { structtype="Uint16_L";            sizeoftype=2; fromtype="Unsigned"; array="no";  }
		else if (intype == "Uint16_B" )           { structtype="Uint16_B";            sizeoftype=2; fromtype="Unsigned"; array="no";  }
		else if (intype == "Uint32_L" )           { structtype="Uint32_L";            sizeoftype=4; fromtype="Unsigned"; array="no";  }
		else if (intype == "Uint32_B" )           { structtype="Uint32_B";            sizeoftype=4; fromtype="Unsigned"; array="no";  }
		else if (intype == "Int8"     )           { structtype="Int8_8";              sizeoftype=1; fromtype="Signed";   array="no";  }
		else if (intype == "Int16_L"  )           { structtype="Int16_L";             sizeoftype=2; fromtype="Signed";   array="no";  }
		else if (intype == "Int16_B"  )           { structtype="Int16_B";             sizeoftype=2; fromtype="Signed";   array="no";  }
		else if (intype == "Int32_L"  )           { structtype="Int32_L";             sizeoftype=4; fromtype="Signed";   array="no";  }
		else if (intype == "Int32_B"  )           { structtype="Int32_B";             sizeoftype=4; fromtype="Signed";   array="no";  }
		else if (intype == "IEEE_Float32_L")      { structtype="IEEE_Float32_L";      sizeoftype=4; fromtype="Double";   array="no";  }
		else if (intype == "IEEE_Float32_B")      { structtype="IEEE_Float32_B";      sizeoftype=4; fromtype="Double";   array="no";  }
		else if (intype == "IEEE_Float64_L")      { structtype="IEEE_Float64_L";      sizeoftype=8; fromtype="Double";   array="no";  }
		else if (intype == "IEEE_Float64_B")      { structtype="IEEE_Float64_B";      sizeoftype=8; fromtype="Double";   array="no";  }
		else if (intype == "Vax_Float_F")         { structtype="Vax_Float_F";         sizeoftype=4; fromtype="Double";   array="no";  }
		else if (intype == "DG_Float_F")          { structtype="DG_Float_F";          sizeoftype=4; fromtype="Double";   array="no";  }
		else if (intype == "Time_Milliseconds_B") { structtype="Time_Milliseconds_B"; sizeoftype=4; fromtype="Time";     array="no";  }
		else if (intype == "Time_Milliseconds_L") { structtype="Time_Milliseconds_L"; sizeoftype=4; fromtype="Time";     array="no";  }
		else if (intype == "Pace_Date")           { structtype="Pace_Date";           sizeoftype=4; fromtype="Date";     array="no";  }
		else if (intype == "Unix_DateTime_L")     { structtype="Unix_DateTime_L";      sizeoftype=4; fromtype="DateTime"; array="no";  }
		else if (intype == "Unix_DateTime_B")     { structtype="Unix_DateTime_B";      sizeoftype=4; fromtype="DateTime"; array="no";  }
		else if (intype == "String_Date_YMD")     { structtype="String";              sizeoftype=1; fromtype="String";   array="yes"; }
		else if (intype == "String_Date_DMY")     { structtype="String";              sizeoftype=1; fromtype="String";   array="yes"; }
		else if (intype == "String_Date_MDY")     { structtype="String";              sizeoftype=1; fromtype="String";   array="yes"; }
		else if (intype == "String_Time")         { structtype="String";              sizeoftype=1; fromtype="String";   array="yes"; }
		else {
			print "Line " FNR ": error in intype - bad type <" \
				intype ">" >"/dev/tty"
			ok="no";
		}

		if (array == "yes") {
			if (inlength == "" || inlength == "?")
				arraylength=1;
			else
				arraylength=inlength
		}
		else {
			arraylength=0
			if (inlength != "" && inlength != "1") {
				print "Line " FNR ": error - no inlength allowed for this type" >"/dev/tty"
				ok="no";
			}
		}
	}

	if (keyword != "" && keyword != "?") {
		usename=keyword
	}
	else if (name != "" && name != "?") {
		usename=name
	}
	else {
		#print "Line " FNR ": error - must have name or keyword" >"/dev/tty"
		#ok="no";
		usename = "unknown" FNR
	}

	if (usemethod == "yes") {
		if (select == "image") {
			valuename=blockinstancename "->" methodname "(imagenumber,\"" usename "\")"
		}
		else {
			valuename=blockinstancename "->" methodname "(\"" usename "\")"
		}
	}
	else {
		if (select == "image") {
			print "Line " FNR ": error - select by image only supported for method not offset" >"/dev/tty"
			ok="no";
		}
		else {
			valuename=blockinstancename "->" usename
		}
	}

	if (block != lastblock) accumulatedoffset=0

	if (ok == "yes") {
		if (role == "headerpart") {
			if (usemethod == "no") {
				if (offset%sizeoftype > 0 && offsetwarning != "off") {
					print "Line " FNR ": warning - offset " offset \
						" % size of type (" sizeoftype \
						" bytes) not zero - possible alignment problem" >"/dev/tty"
				}
				lengthtopad=offset-accumulatedoffset
				if (lengthtopad > 0) {
					++reservedfieldcount
					print "\tchar \t\treserved_" reservedfieldcount "\t[" lengthtopad "]\t;"
					accumulatedoffset+=lengthtopad
				}
				else if (lengthtopad < 0) {
					print "Line " FNR ": error - offset " offset \
						" < the " accumulatedoffset " already allocated" >"/dev/tty"
				}
				if (arraylength == 0)
					part=structtype " \t" usename
				else if (fromtype == "String")
					part=structtype "<" arraylength "> \t" usename
				else
					part=structtype " \t" usename "[" arraylength "]"

				print "\t" part "\t; // at " accumulatedoffset

				if (arraylength == 0)
					accumulatedoffset+=sizeoftype
				else
					accumulatedoffset+=sizeoftype*arraylength
			}
		}

		if (fromtype == "String")
			putname="String_Use(" valuename ")"
		else if (dicomtype == "DA")
			putname="Date(" valuename ")"
		else if (dicomtype == "TM")
			putname="Time(" valuename ")"
		else
			putname=valuename

		if (role == "dicom" && putdicom == "yes") {
			print "\t" conditiontest "(*list)+=new " dicomtypedesc "Attribute("
			print "\t\tTagFromName(" dicomtag "),"
			print "\t\t" putname ");"
			print ""
		}
		if (role == "dump") {
			if (keyword != "" && keyword != "?")
				keydesc=" (" keyword ")"
			else if (name != "" && name != "?")
				keydesc=" (" name ")"
			else
				keydesc=""

			if (usemethod == "no") {
				offsetdescription="\"[\" << " offsetname " << \":\" << " offset " << \"] \""
			}
			else {
				offsetdescription="\"[" block ":" keyword "] \""
			}

			print "\t" conditiontest "(*log)\t << " offsetdescription "<< \"\\t" comment keydesc "\\t <\""

			if (fromtype == "Date") {
				print "\t\t <<          Date(" putname ").getYYYY()"
				print "\t\t << \"/\" << Date(" putname ").getMMM()"
				print "\t\t << \"/\" << Date(" putname ").getDD()"
			}
			else if (fromtype == "Time") {
				print "\t\t <<          Time(" putname ").getHour()"
				print "\t\t << \":\" << Time(" putname ").getMinute()"
				print "\t\t << \":\" << Time(" putname ").getSecond()"
			}
			else if (fromtype == "DateTime") {
				print "\t\t <<          DateTime(" putname ").getYYYY()"
				print "\t\t << \"/\" << DateTime(" putname ").getMMM()"
				print "\t\t << \"/\" << DateTime(" putname ").getDD()"
				print "\t\t << \" \" << DateTime(" putname ").getHour()"
				print "\t\t << \":\" << DateTime(" putname ").getMinute()"
				print "\t\t << \":\" << DateTime(" putname ").getSecond()"
			}
			else {
				print "\t\t << " putname
			}
			print "\t\t << \">\\n\";"

			while (enum != "") {
				#if (!match(enum,"[a-zA-Z\'0-9\-][a-zA-Z\'0-9]*=")) {
				if (!match(enum,"[^=]*=")) {
					print "Line " FNR \
						": error in enum - no code <" \
						enum ">" >"/dev/tty"
					next
				}
				code=substr(enum,RSTART,RLENGTH-1)
				enum=substr(enum,RSTART+RLENGTH)
				if (!match(enum,"[^,][^,]*")) {
					print "Line " FNR \
						": error in enum - no value <" \
						enum ">" >"/dev/tty"
					next
				}
				meaning=substr(enum,RSTART,RLENGTH)
				enum=substr(enum,RSTART+RLENGTH)
				if (match(code,"\'")) {
					unquotecode=substr(code,2,length(code)-2);
					print "\t" conditiontest "if (strncmp(" putname ",\"" unquotecode \
						"\"," arraylength ")==0) (*log) << \"\\t\\t " \
						code " = " meaning "\\n\";"
				}
				else {
					print "\t" conditiontest "if (" putname " == " code \
						") (*log) << \"\\t\\t\\t " \
						code " = " meaning "\\n\";"
				}
				if (match(enum,"^,")) {
					enum=substr(enum,RSTART+RLENGTH)
				}
				else {
					if (length(enum) != 0) {
					print "Line " FNR \
						": error in enum - trailing garbage <" \
						enum ">" >"/dev/tty"
					}
					next
				}
			}

			while (bitmap != "") {
				if (!match(bitmap,"[0-9][0-9]*:")) {
					print "Line " FNR \
						": error in bitmap - no bit number <" \
						bitmap ">" >"/dev/tty"
					next
				}
				bitnumber=substr(bitmap,RSTART,RLENGTH-1)
				bitmap=substr(bitmap,RSTART+RLENGTH)

				if (!match(bitmap,"[^,;][^,;]*")) {
					print "Line " FNR \
						": error in bitmap - no false value <" \
						bitmap ">" >"/dev/tty"
					next
				}
				zeromeaning=substr(bitmap,RSTART,RLENGTH)
				bitmap=substr(bitmap,RSTART+RLENGTH)

				if (match(bitmap,"^,")) {
					bitmap=substr(bitmap,RSTART+RLENGTH)
				}
				else {
					print "Line " FNR \
						": error in bitmap - no comma <" \
						bitmap ">" >"/dev/tty"
					next
				}

				if (!match(bitmap,"[^;,][^;,]*")) {
					print "Line " FNR \
						": error in bitmap - no true value <" \
						bitmap ">" >"/dev/tty"
					next
				}
				onemeaning=substr(bitmap,RSTART,RLENGTH)
				bitmap=substr(bitmap,RSTART+RLENGTH)

				print "\t" conditiontest "(*log) << \"\\t\\t\\t bit " bitnumber " \""
				print "\t     << ((" putname "&(1<<" bitnumber "))?\"true \":\"false\") "
				print "\t     << \" = \" << ((" putname "&(1<<" bitnumber "))?\"" onemeaning \
						"\":\"" zeromeaning "\")"
				print "\t     << \"\\n\";"

				if (match(bitmap,"^;")) {
					bitmap=substr(bitmap,RSTART+RLENGTH)
				}
				else {
					if (length(bitmap) != 0) {
					print "Line " FNR \
					    ": error in bitmap - trailing garbage <" \
						bitmap ">" >"/dev/tty"
					}
					next
				}
			}

		}
	}
	lastblock=block
}

/^constant/{
	constant=""
	if (match($0,"constant=\"[^\"]*\""))
		constant=substr($0,RSTART+length("constant=\""),
			RLENGTH-length("constant=\"")-1);
	condition=""
	if (match($0,"condition=\"[^\"]*\""))
		condition=substr($0,RSTART+length("condition=\""),
			RLENGTH-length("condition=\"")-1);
	dicomtype=""
	if (match($0,"dicomtype=\"[^\"]*\""))
		dicomtype=substr($0,RSTART+length("dicomtype=\""),
			RLENGTH-length("dicomtype=\"")-1);
	dicomtag=""
	if (match($0,"dicomtag=\"[^\"]*\""))
		dicomtag=substr($0,RSTART+length("dicomtag=\""),
			RLENGTH-length("dicomtag=\"")-1);

	ok="yes";

	if (condition == "")
		conditiontest=""
	else
		conditiontest="if (" conditionprefix condition ") "

	if (role == "dicom") {
		if (dicomtype == "" || dicomtype == "?" ) {
			print "Line " FNR ": error - no dicomtype" >"/dev/tty"
			ok="no";
		}
		if (dicomtag == "" || dicomtag == "?" ) {
			print "Line " FNR ": error - no dicomtag" >"/dev/tty"
			ok="no";
		}

		if      (dicomtype == "AE") { dicomtypedesc="ApplicationEntity" ; fromtype="String"; }
		else if (dicomtype == "AS") { dicomtypedesc="AgeString"         ; fromtype="String"; }
		else if (dicomtype == "CS") { dicomtypedesc="CodeString"        ; fromtype="String"; }
		else if (dicomtype == "DA") { dicomtypedesc="DateString"        ; fromtype="String"; }
		else if (dicomtype == "DS") { dicomtypedesc="DecimalString"     ; fromtype="String"; }
		else if (dicomtype == "DT") { dicomtypedesc="DateTimeString"    ; fromtype="String"; }
		else if (dicomtype == "IS") { dicomtypedesc="IntegerString"     ; fromtype="String"; }
		else if (dicomtype == "LO") { dicomtypedesc="LongString"        ; fromtype="String"; }
		else if (dicomtype == "LT") { dicomtypedesc="LongText"          ; fromtype="String"; }
		else if (dicomtype == "PN") { dicomtypedesc="PersonName"        ; fromtype="String"; }
		else if (dicomtype == "SH") { dicomtypedesc="ShortString"       ; fromtype="String"; }
		else if (dicomtype == "SL") { dicomtypedesc="SignedLong"        ; fromtype="Signed"; }
		else if (dicomtype == "SS") { dicomtypedesc="SignedShort"       ; fromtype="Signed"; }
		else if (dicomtype == "ST") { dicomtypedesc="ShortText"         ; fromtype="String"; }
		else if (dicomtype == "TM") { dicomtypedesc="TimeString"        ; fromtype="String"; }
		else if (dicomtype == "UI") { dicomtypedesc="UIString"          ; fromtype="String"; }
		else if (dicomtype == "UL") { dicomtypedesc="UnsignedLong"      ; fromtype="Unsigned"; }
		else if (dicomtype == "US") { dicomtypedesc="UnsignedShort"     ; fromtype="Unsigned"; }
		else if (dicomtype == "XS") { dicomtypedesc="UnspecifiedShort"  ; fromtype="Unsigned"; }
		else if (dicomtype == "XL") { dicomtypedesc="UnspecifiedLong"   ; fromtype="Unsigned"; }
		else {
			print "Line " FNR ": error in dicomtype - bad or unsupported type <" \
				dicomtype ">" >"/dev/tty"
			ok="no";
		}

		if (constant == "")
			usevalue="";
		else if (fromtype == "String")
			usevalue=",\"" constant "\"";
		else
			usevalue="," constant;

		if (ok == "yes") {
			print "\t" conditiontest "(*list)+=new " dicomtypedesc "Attribute("
			print "\t\tTagFromName(" dicomtag ")" usevalue ");"
			print ""
		}
	}
}

END {
	if (role == "headerpart") {
		if (lastblock != "") {
			print "};"
			print ""
		}
	}
	if (role == "wholeheader") {
		print "};"
	}
	if (role == "dicom" || role == "dump" || role == "constructheader") {
		print "}"
		print ""
	}
}
