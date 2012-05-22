AC_INIT([herbrand],[1.0])



AC_CHECK_TOOL([OCAML],[ocaml],[no])
if test "$OCAML" = "no"; then
	AC_MSG_ERROR([ocaml top level not found])
fi

AC_CHECK_TOOL([OCAMLC],[ocamlc],[no])
if test "$OCAMLC" = "no"; then
	AC_MSG_ERROR([ocamlc not found])
fi

AC_CHECK_TOOL([OCAMLDEP],[ocamldep],[no])
if test "$OCAMLDEP" = "no"; then
	AC_MSG_ERROR([ocamldep not found])
fi

AC_CHECK_TOOL([OCAMLLEX],[ocamllex],[no])
if test "$OCAMLLEX" = "no"; then
	AC_MSG_ERROR([OcamlLex not found])
fi

AC_CHECK_TOOL([OCAMLYACC],[ocamlyacc],[no])
if test "$OCAMLYACC" = "no"; then
	AC_MSG_ERROR([OcamlYacc not found])
fi

AC_CHECK_PROG(OCAMLDOC,ocamldoc,ocamldoc,true)
if test "$OCAMLDOC" = true ; then
    AC_MSG_ERROR(Cannot find ocamldoc)
fi

dnl we extract Ocaml version number and library path
OCAMLVERSION=`$OCAMLC -v | sed -n -e 's|.*version *\(.*\)$|\1|p' `
echo "ocaml version is $OCAMLVERSION"
OCAMLLIB=`$OCAMLC -v | tail -1 | cut -f 4 -d " " | sed 's/\/\//\//g'`
echo "ocaml library path is $OCAMLLIB"


AC_SUBST([OCAMLC])
AC_SUBST([OCAML])
AC_SUBST([OCAMLDEP])
AC_SUBST([OCAMLMKTOP])
AC_SUBST([OCAMLLEX])
AC_SUBST([OCAMLYACC])
AC_SUBST([OCAMLDOC])


#AC_CONFIG_FILES([Makefile])
AC_OUTPUT
