#! /bin/sh
# $Id$
# $Log$
# Revision 1.6  2002/05/19 13:01:22  geraint
# Numerical solution of algebraic equations implemented for S-function target.
#
# Equation solving requires the Matlab Optimization Toolbox to be installed.
#
# Code has been changed from C++ to C to allow mex files to be built with LCC,
# the compiler bundled with Matlab.
#
# Parameters are now obtained from numpar.c instead of a dialogue box.
#
# `mtt <sys> sfun zip` creates all necessary files for building the model mex files.
#
# Revision 1.5  2002/04/28 18:58:06  geraint
# Fixed [ 549658 ] awk should be gawk.
# Replaced calls to awk with call to gawk.
#
# Revision 1.4  2001/08/24 21:41:04  geraint
# Fixed problem with declaration when there are no numerical parameters.
#
# Revision 1.3  2001/03/19 02:28:53  geraint
# Branch merge: merging-ode2odes-exe back to MAIN.
#
# Revision 1.2.2.1  2001/03/16 03:56:54  geraint
# Convert variable names to lower case.
#
# Revision 1.2  2001/02/05 13:03:19  geraint
# Restrict scope of variables to file (static).
# Warn GCC that variables may be unused.
#
# Revision 1.7  2001/01/09 15:43:50  geraint
# Warn gcc that variables may be unused.
#
# Revision 1.6  2001/01/08 05:47:56  geraint
# Restrict scope of variables to file (static)
#
# Revision 1.5  2000/12/05 12:44:55  peterg
# Changed $() to ``
#
# Revision 1.4  2000/12/05 12:16:02  peterg
# Changed function name to name()
#
# Revision 1.3  2000/12/04 11:05:01  peterg
# Removed () -- geraint
#
# Revision 1.2  2000/11/07 17:29:27  peterg
# Changed echo
#
# Revision 1.1  2000/11/07 17:28:53  peterg
# Initial revision
#
# Revision 1.1  2000/10/31 04:32:02  geraint
# Initial revision
#

SYS=$1

if [ $# -gt 1 ]
then
  NUM_OF_TMP_VAR=$2;
  shift; shift;
else
  NUM_OF_TMP_VAR=500
  shift;
fi
TMP_VAR_NAMES="mtt_tmp mtt_o $*"

IN=${SYS}_sympar.txt
OUT=${SYS}_sympar.h

declare_sys_param ()
{
cat ${IN} | gawk '(NF>0){printf ("static double %s MTT_UNUSED;\t/* %s\t*/\n", tolower($1), $2)}'
}

declare_temp_vars ()
{
for name in ${TMP_VAR_NAMES}
do
    echo ""

    cat <<EOF | head -`expr ${NUM_OF_TMP_VAR} + 1`
static double ${name}0 MTT_UNUSED;
static double ${name}1 MTT_UNUSED;
static double ${name}2 MTT_UNUSED;
static double ${name}3 MTT_UNUSED;
static double ${name}4 MTT_UNUSED;
static double ${name}5 MTT_UNUSED;
static double ${name}6 MTT_UNUSED;
static double ${name}7 MTT_UNUSED;
static double ${name}8 MTT_UNUSED;
static double ${name}9 MTT_UNUSED;
static double ${name}10 MTT_UNUSED;
static double ${name}11 MTT_UNUSED;
static double ${name}12 MTT_UNUSED;
static double ${name}13 MTT_UNUSED;
static double ${name}14 MTT_UNUSED;
static double ${name}15 MTT_UNUSED;
static double ${name}16 MTT_UNUSED;
static double ${name}17 MTT_UNUSED;
static double ${name}18 MTT_UNUSED;
static double ${name}19 MTT_UNUSED;
static double ${name}20 MTT_UNUSED;
static double ${name}21 MTT_UNUSED;
static double ${name}22 MTT_UNUSED;
static double ${name}23 MTT_UNUSED;
static double ${name}24 MTT_UNUSED;
static double ${name}25 MTT_UNUSED;
static double ${name}26 MTT_UNUSED;
static double ${name}27 MTT_UNUSED;
static double ${name}28 MTT_UNUSED;
static double ${name}29 MTT_UNUSED;
static double ${name}30 MTT_UNUSED;
static double ${name}31 MTT_UNUSED;
static double ${name}32 MTT_UNUSED;
static double ${name}33 MTT_UNUSED;
static double ${name}34 MTT_UNUSED;
static double ${name}35 MTT_UNUSED;
static double ${name}36 MTT_UNUSED;
static double ${name}37 MTT_UNUSED;
static double ${name}38 MTT_UNUSED;
static double ${name}39 MTT_UNUSED;
static double ${name}40 MTT_UNUSED;
static double ${name}41 MTT_UNUSED;
static double ${name}42 MTT_UNUSED;
static double ${name}43 MTT_UNUSED;
static double ${name}44 MTT_UNUSED;
static double ${name}45 MTT_UNUSED;
static double ${name}46 MTT_UNUSED;
static double ${name}47 MTT_UNUSED;
static double ${name}48 MTT_UNUSED;
static double ${name}49 MTT_UNUSED;
static double ${name}50 MTT_UNUSED;
static double ${name}51 MTT_UNUSED;
static double ${name}52 MTT_UNUSED;
static double ${name}53 MTT_UNUSED;
static double ${name}54 MTT_UNUSED;
static double ${name}55 MTT_UNUSED;
static double ${name}56 MTT_UNUSED;
static double ${name}57 MTT_UNUSED;
static double ${name}58 MTT_UNUSED;
static double ${name}59 MTT_UNUSED;
static double ${name}60 MTT_UNUSED;
static double ${name}61 MTT_UNUSED;
static double ${name}62 MTT_UNUSED;
static double ${name}63 MTT_UNUSED;
static double ${name}64 MTT_UNUSED;
static double ${name}65 MTT_UNUSED;
static double ${name}66 MTT_UNUSED;
static double ${name}67 MTT_UNUSED;
static double ${name}68 MTT_UNUSED;
static double ${name}69 MTT_UNUSED;
static double ${name}70 MTT_UNUSED;
static double ${name}71 MTT_UNUSED;
static double ${name}72 MTT_UNUSED;
static double ${name}73 MTT_UNUSED;
static double ${name}74 MTT_UNUSED;
static double ${name}75 MTT_UNUSED;
static double ${name}76 MTT_UNUSED;
static double ${name}77 MTT_UNUSED;
static double ${name}78 MTT_UNUSED;
static double ${name}79 MTT_UNUSED;
static double ${name}80 MTT_UNUSED;
static double ${name}81 MTT_UNUSED;
static double ${name}82 MTT_UNUSED;
static double ${name}83 MTT_UNUSED;
static double ${name}84 MTT_UNUSED;
static double ${name}85 MTT_UNUSED;
static double ${name}86 MTT_UNUSED;
static double ${name}87 MTT_UNUSED;
static double ${name}88 MTT_UNUSED;
static double ${name}89 MTT_UNUSED;
static double ${name}90 MTT_UNUSED;
static double ${name}91 MTT_UNUSED;
static double ${name}92 MTT_UNUSED;
static double ${name}93 MTT_UNUSED;
static double ${name}94 MTT_UNUSED;
static double ${name}95 MTT_UNUSED;
static double ${name}96 MTT_UNUSED;
static double ${name}97 MTT_UNUSED;
static double ${name}98 MTT_UNUSED;
static double ${name}99 MTT_UNUSED;
static double ${name}100 MTT_UNUSED;
static double ${name}101 MTT_UNUSED;
static double ${name}102 MTT_UNUSED;
static double ${name}103 MTT_UNUSED;
static double ${name}104 MTT_UNUSED;
static double ${name}105 MTT_UNUSED;
static double ${name}106 MTT_UNUSED;
static double ${name}107 MTT_UNUSED;
static double ${name}108 MTT_UNUSED;
static double ${name}109 MTT_UNUSED;
static double ${name}110 MTT_UNUSED;
static double ${name}111 MTT_UNUSED;
static double ${name}112 MTT_UNUSED;
static double ${name}113 MTT_UNUSED;
static double ${name}114 MTT_UNUSED;
static double ${name}115 MTT_UNUSED;
static double ${name}116 MTT_UNUSED;
static double ${name}117 MTT_UNUSED;
static double ${name}118 MTT_UNUSED;
static double ${name}119 MTT_UNUSED;
static double ${name}120 MTT_UNUSED;
static double ${name}121 MTT_UNUSED;
static double ${name}122 MTT_UNUSED;
static double ${name}123 MTT_UNUSED;
static double ${name}124 MTT_UNUSED;
static double ${name}125 MTT_UNUSED;
static double ${name}126 MTT_UNUSED;
static double ${name}127 MTT_UNUSED;
static double ${name}128 MTT_UNUSED;
static double ${name}129 MTT_UNUSED;
static double ${name}130 MTT_UNUSED;
static double ${name}131 MTT_UNUSED;
static double ${name}132 MTT_UNUSED;
static double ${name}133 MTT_UNUSED;
static double ${name}134 MTT_UNUSED;
static double ${name}135 MTT_UNUSED;
static double ${name}136 MTT_UNUSED;
static double ${name}137 MTT_UNUSED;
static double ${name}138 MTT_UNUSED;
static double ${name}139 MTT_UNUSED;
static double ${name}140 MTT_UNUSED;
static double ${name}141 MTT_UNUSED;
static double ${name}142 MTT_UNUSED;
static double ${name}143 MTT_UNUSED;
static double ${name}144 MTT_UNUSED;
static double ${name}145 MTT_UNUSED;
static double ${name}146 MTT_UNUSED;
static double ${name}147 MTT_UNUSED;
static double ${name}148 MTT_UNUSED;
static double ${name}149 MTT_UNUSED;
static double ${name}150 MTT_UNUSED;
static double ${name}151 MTT_UNUSED;
static double ${name}152 MTT_UNUSED;
static double ${name}153 MTT_UNUSED;
static double ${name}154 MTT_UNUSED;
static double ${name}155 MTT_UNUSED;
static double ${name}156 MTT_UNUSED;
static double ${name}157 MTT_UNUSED;
static double ${name}158 MTT_UNUSED;
static double ${name}159 MTT_UNUSED;
static double ${name}160 MTT_UNUSED;
static double ${name}161 MTT_UNUSED;
static double ${name}162 MTT_UNUSED;
static double ${name}163 MTT_UNUSED;
static double ${name}164 MTT_UNUSED;
static double ${name}165 MTT_UNUSED;
static double ${name}166 MTT_UNUSED;
static double ${name}167 MTT_UNUSED;
static double ${name}168 MTT_UNUSED;
static double ${name}169 MTT_UNUSED;
static double ${name}170 MTT_UNUSED;
static double ${name}171 MTT_UNUSED;
static double ${name}172 MTT_UNUSED;
static double ${name}173 MTT_UNUSED;
static double ${name}174 MTT_UNUSED;
static double ${name}175 MTT_UNUSED;
static double ${name}176 MTT_UNUSED;
static double ${name}177 MTT_UNUSED;
static double ${name}178 MTT_UNUSED;
static double ${name}179 MTT_UNUSED;
static double ${name}180 MTT_UNUSED;
static double ${name}181 MTT_UNUSED;
static double ${name}182 MTT_UNUSED;
static double ${name}183 MTT_UNUSED;
static double ${name}184 MTT_UNUSED;
static double ${name}185 MTT_UNUSED;
static double ${name}186 MTT_UNUSED;
static double ${name}187 MTT_UNUSED;
static double ${name}188 MTT_UNUSED;
static double ${name}189 MTT_UNUSED;
static double ${name}190 MTT_UNUSED;
static double ${name}191 MTT_UNUSED;
static double ${name}192 MTT_UNUSED;
static double ${name}193 MTT_UNUSED;
static double ${name}194 MTT_UNUSED;
static double ${name}195 MTT_UNUSED;
static double ${name}196 MTT_UNUSED;
static double ${name}197 MTT_UNUSED;
static double ${name}198 MTT_UNUSED;
static double ${name}199 MTT_UNUSED;
static double ${name}200 MTT_UNUSED;
static double ${name}201 MTT_UNUSED;
static double ${name}202 MTT_UNUSED;
static double ${name}203 MTT_UNUSED;
static double ${name}204 MTT_UNUSED;
static double ${name}205 MTT_UNUSED;
static double ${name}206 MTT_UNUSED;
static double ${name}207 MTT_UNUSED;
static double ${name}208 MTT_UNUSED;
static double ${name}209 MTT_UNUSED;
static double ${name}210 MTT_UNUSED;
static double ${name}211 MTT_UNUSED;
static double ${name}212 MTT_UNUSED;
static double ${name}213 MTT_UNUSED;
static double ${name}214 MTT_UNUSED;
static double ${name}215 MTT_UNUSED;
static double ${name}216 MTT_UNUSED;
static double ${name}217 MTT_UNUSED;
static double ${name}218 MTT_UNUSED;
static double ${name}219 MTT_UNUSED;
static double ${name}220 MTT_UNUSED;
static double ${name}221 MTT_UNUSED;
static double ${name}222 MTT_UNUSED;
static double ${name}223 MTT_UNUSED;
static double ${name}224 MTT_UNUSED;
static double ${name}225 MTT_UNUSED;
static double ${name}226 MTT_UNUSED;
static double ${name}227 MTT_UNUSED;
static double ${name}228 MTT_UNUSED;
static double ${name}229 MTT_UNUSED;
static double ${name}230 MTT_UNUSED;
static double ${name}231 MTT_UNUSED;
static double ${name}232 MTT_UNUSED;
static double ${name}233 MTT_UNUSED;
static double ${name}234 MTT_UNUSED;
static double ${name}235 MTT_UNUSED;
static double ${name}236 MTT_UNUSED;
static double ${name}237 MTT_UNUSED;
static double ${name}238 MTT_UNUSED;
static double ${name}239 MTT_UNUSED;
static double ${name}240 MTT_UNUSED;
static double ${name}241 MTT_UNUSED;
static double ${name}242 MTT_UNUSED;
static double ${name}243 MTT_UNUSED;
static double ${name}244 MTT_UNUSED;
static double ${name}245 MTT_UNUSED;
static double ${name}246 MTT_UNUSED;
static double ${name}247 MTT_UNUSED;
static double ${name}248 MTT_UNUSED;
static double ${name}249 MTT_UNUSED;
static double ${name}250 MTT_UNUSED;
static double ${name}251 MTT_UNUSED;
static double ${name}252 MTT_UNUSED;
static double ${name}253 MTT_UNUSED;
static double ${name}254 MTT_UNUSED;
static double ${name}255 MTT_UNUSED;
static double ${name}256 MTT_UNUSED;
static double ${name}257 MTT_UNUSED;
static double ${name}258 MTT_UNUSED;
static double ${name}259 MTT_UNUSED;
static double ${name}260 MTT_UNUSED;
static double ${name}261 MTT_UNUSED;
static double ${name}262 MTT_UNUSED;
static double ${name}263 MTT_UNUSED;
static double ${name}264 MTT_UNUSED;
static double ${name}265 MTT_UNUSED;
static double ${name}266 MTT_UNUSED;
static double ${name}267 MTT_UNUSED;
static double ${name}268 MTT_UNUSED;
static double ${name}269 MTT_UNUSED;
static double ${name}270 MTT_UNUSED;
static double ${name}271 MTT_UNUSED;
static double ${name}272 MTT_UNUSED;
static double ${name}273 MTT_UNUSED;
static double ${name}274 MTT_UNUSED;
static double ${name}275 MTT_UNUSED;
static double ${name}276 MTT_UNUSED;
static double ${name}277 MTT_UNUSED;
static double ${name}278 MTT_UNUSED;
static double ${name}279 MTT_UNUSED;
static double ${name}280 MTT_UNUSED;
static double ${name}281 MTT_UNUSED;
static double ${name}282 MTT_UNUSED;
static double ${name}283 MTT_UNUSED;
static double ${name}284 MTT_UNUSED;
static double ${name}285 MTT_UNUSED;
static double ${name}286 MTT_UNUSED;
static double ${name}287 MTT_UNUSED;
static double ${name}288 MTT_UNUSED;
static double ${name}289 MTT_UNUSED;
static double ${name}290 MTT_UNUSED;
static double ${name}291 MTT_UNUSED;
static double ${name}292 MTT_UNUSED;
static double ${name}293 MTT_UNUSED;
static double ${name}294 MTT_UNUSED;
static double ${name}295 MTT_UNUSED;
static double ${name}296 MTT_UNUSED;
static double ${name}297 MTT_UNUSED;
static double ${name}298 MTT_UNUSED;
static double ${name}299 MTT_UNUSED;
static double ${name}300 MTT_UNUSED;
static double ${name}301 MTT_UNUSED;
static double ${name}302 MTT_UNUSED;
static double ${name}303 MTT_UNUSED;
static double ${name}304 MTT_UNUSED;
static double ${name}305 MTT_UNUSED;
static double ${name}306 MTT_UNUSED;
static double ${name}307 MTT_UNUSED;
static double ${name}308 MTT_UNUSED;
static double ${name}309 MTT_UNUSED;
static double ${name}310 MTT_UNUSED;
static double ${name}311 MTT_UNUSED;
static double ${name}312 MTT_UNUSED;
static double ${name}313 MTT_UNUSED;
static double ${name}314 MTT_UNUSED;
static double ${name}315 MTT_UNUSED;
static double ${name}316 MTT_UNUSED;
static double ${name}317 MTT_UNUSED;
static double ${name}318 MTT_UNUSED;
static double ${name}319 MTT_UNUSED;
static double ${name}320 MTT_UNUSED;
static double ${name}321 MTT_UNUSED;
static double ${name}322 MTT_UNUSED;
static double ${name}323 MTT_UNUSED;
static double ${name}324 MTT_UNUSED;
static double ${name}325 MTT_UNUSED;
static double ${name}326 MTT_UNUSED;
static double ${name}327 MTT_UNUSED;
static double ${name}328 MTT_UNUSED;
static double ${name}329 MTT_UNUSED;
static double ${name}330 MTT_UNUSED;
static double ${name}331 MTT_UNUSED;
static double ${name}332 MTT_UNUSED;
static double ${name}333 MTT_UNUSED;
static double ${name}334 MTT_UNUSED;
static double ${name}335 MTT_UNUSED;
static double ${name}336 MTT_UNUSED;
static double ${name}337 MTT_UNUSED;
static double ${name}338 MTT_UNUSED;
static double ${name}339 MTT_UNUSED;
static double ${name}340 MTT_UNUSED;
static double ${name}341 MTT_UNUSED;
static double ${name}342 MTT_UNUSED;
static double ${name}343 MTT_UNUSED;
static double ${name}344 MTT_UNUSED;
static double ${name}345 MTT_UNUSED;
static double ${name}346 MTT_UNUSED;
static double ${name}347 MTT_UNUSED;
static double ${name}348 MTT_UNUSED;
static double ${name}349 MTT_UNUSED;
static double ${name}350 MTT_UNUSED;
static double ${name}351 MTT_UNUSED;
static double ${name}352 MTT_UNUSED;
static double ${name}353 MTT_UNUSED;
static double ${name}354 MTT_UNUSED;
static double ${name}355 MTT_UNUSED;
static double ${name}356 MTT_UNUSED;
static double ${name}357 MTT_UNUSED;
static double ${name}358 MTT_UNUSED;
static double ${name}359 MTT_UNUSED;
static double ${name}360 MTT_UNUSED;
static double ${name}361 MTT_UNUSED;
static double ${name}362 MTT_UNUSED;
static double ${name}363 MTT_UNUSED;
static double ${name}364 MTT_UNUSED;
static double ${name}365 MTT_UNUSED;
static double ${name}366 MTT_UNUSED;
static double ${name}367 MTT_UNUSED;
static double ${name}368 MTT_UNUSED;
static double ${name}369 MTT_UNUSED;
static double ${name}370 MTT_UNUSED;
static double ${name}371 MTT_UNUSED;
static double ${name}372 MTT_UNUSED;
static double ${name}373 MTT_UNUSED;
static double ${name}374 MTT_UNUSED;
static double ${name}375 MTT_UNUSED;
static double ${name}376 MTT_UNUSED;
static double ${name}377 MTT_UNUSED;
static double ${name}378 MTT_UNUSED;
static double ${name}379 MTT_UNUSED;
static double ${name}380 MTT_UNUSED;
static double ${name}381 MTT_UNUSED;
static double ${name}382 MTT_UNUSED;
static double ${name}383 MTT_UNUSED;
static double ${name}384 MTT_UNUSED;
static double ${name}385 MTT_UNUSED;
static double ${name}386 MTT_UNUSED;
static double ${name}387 MTT_UNUSED;
static double ${name}388 MTT_UNUSED;
static double ${name}389 MTT_UNUSED;
static double ${name}390 MTT_UNUSED;
static double ${name}391 MTT_UNUSED;
static double ${name}392 MTT_UNUSED;
static double ${name}393 MTT_UNUSED;
static double ${name}394 MTT_UNUSED;
static double ${name}395 MTT_UNUSED;
static double ${name}396 MTT_UNUSED;
static double ${name}397 MTT_UNUSED;
static double ${name}398 MTT_UNUSED;
static double ${name}399 MTT_UNUSED;
static double ${name}400 MTT_UNUSED;
static double ${name}401 MTT_UNUSED;
static double ${name}402 MTT_UNUSED;
static double ${name}403 MTT_UNUSED;
static double ${name}404 MTT_UNUSED;
static double ${name}405 MTT_UNUSED;
static double ${name}406 MTT_UNUSED;
static double ${name}407 MTT_UNUSED;
static double ${name}408 MTT_UNUSED;
static double ${name}409 MTT_UNUSED;
static double ${name}410 MTT_UNUSED;
static double ${name}411 MTT_UNUSED;
static double ${name}412 MTT_UNUSED;
static double ${name}413 MTT_UNUSED;
static double ${name}414 MTT_UNUSED;
static double ${name}415 MTT_UNUSED;
static double ${name}416 MTT_UNUSED;
static double ${name}417 MTT_UNUSED;
static double ${name}418 MTT_UNUSED;
static double ${name}419 MTT_UNUSED;
static double ${name}420 MTT_UNUSED;
static double ${name}421 MTT_UNUSED;
static double ${name}422 MTT_UNUSED;
static double ${name}423 MTT_UNUSED;
static double ${name}424 MTT_UNUSED;
static double ${name}425 MTT_UNUSED;
static double ${name}426 MTT_UNUSED;
static double ${name}427 MTT_UNUSED;
static double ${name}428 MTT_UNUSED;
static double ${name}429 MTT_UNUSED;
static double ${name}430 MTT_UNUSED;
static double ${name}431 MTT_UNUSED;
static double ${name}432 MTT_UNUSED;
static double ${name}433 MTT_UNUSED;
static double ${name}434 MTT_UNUSED;
static double ${name}435 MTT_UNUSED;
static double ${name}436 MTT_UNUSED;
static double ${name}437 MTT_UNUSED;
static double ${name}438 MTT_UNUSED;
static double ${name}439 MTT_UNUSED;
static double ${name}440 MTT_UNUSED;
static double ${name}441 MTT_UNUSED;
static double ${name}442 MTT_UNUSED;
static double ${name}443 MTT_UNUSED;
static double ${name}444 MTT_UNUSED;
static double ${name}445 MTT_UNUSED;
static double ${name}446 MTT_UNUSED;
static double ${name}447 MTT_UNUSED;
static double ${name}448 MTT_UNUSED;
static double ${name}449 MTT_UNUSED;
static double ${name}450 MTT_UNUSED;
static double ${name}451 MTT_UNUSED;
static double ${name}452 MTT_UNUSED;
static double ${name}453 MTT_UNUSED;
static double ${name}454 MTT_UNUSED;
static double ${name}455 MTT_UNUSED;
static double ${name}456 MTT_UNUSED;
static double ${name}457 MTT_UNUSED;
static double ${name}458 MTT_UNUSED;
static double ${name}459 MTT_UNUSED;
static double ${name}460 MTT_UNUSED;
static double ${name}461 MTT_UNUSED;
static double ${name}462 MTT_UNUSED;
static double ${name}463 MTT_UNUSED;
static double ${name}464 MTT_UNUSED;
static double ${name}465 MTT_UNUSED;
static double ${name}466 MTT_UNUSED;
static double ${name}467 MTT_UNUSED;
static double ${name}468 MTT_UNUSED;
static double ${name}469 MTT_UNUSED;
static double ${name}470 MTT_UNUSED;
static double ${name}471 MTT_UNUSED;
static double ${name}472 MTT_UNUSED;
static double ${name}473 MTT_UNUSED;
static double ${name}474 MTT_UNUSED;
static double ${name}475 MTT_UNUSED;
static double ${name}476 MTT_UNUSED;
static double ${name}477 MTT_UNUSED;
static double ${name}478 MTT_UNUSED;
static double ${name}479 MTT_UNUSED;
static double ${name}480 MTT_UNUSED;
static double ${name}481 MTT_UNUSED;
static double ${name}482 MTT_UNUSED;
static double ${name}483 MTT_UNUSED;
static double ${name}484 MTT_UNUSED;
static double ${name}485 MTT_UNUSED;
static double ${name}486 MTT_UNUSED;
static double ${name}487 MTT_UNUSED;
static double ${name}488 MTT_UNUSED;
static double ${name}489 MTT_UNUSED;
static double ${name}490 MTT_UNUSED;
static double ${name}491 MTT_UNUSED;
static double ${name}492 MTT_UNUSED;
static double ${name}493 MTT_UNUSED;
static double ${name}494 MTT_UNUSED;
static double ${name}495 MTT_UNUSED;
static double ${name}496 MTT_UNUSED;
static double ${name}497 MTT_UNUSED;
static double ${name}498 MTT_UNUSED;
static double ${name}499 MTT_UNUSED;
static double ${name}500 MTT_UNUSED;
EOF

    if [ ${NUM_OF_TMP_VAR} -gt 500 ]; then
	i=501
	while [ ${i} -le ${NUM_OF_TMP_VAR} ]
	do
	  echo "static double ${name}${i} MTT_UNUSED;"
	  i=`expr ${i} + 1`
	done
    fi
done
}

echo Creating ${OUT}
cat <<EOF > ${OUT}
#ifndef MTT_UNUSED
#ifdef __GNUC__
#define MTT_UNUSED __attribute__ ((__unused__))
#else
#define MTT_UNUSED
#endif
#endif

EOF

declare_sys_param	>> ${OUT}
declare_temp_vars	>> ${OUT}

