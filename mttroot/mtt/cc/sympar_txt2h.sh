#! /bin/sh
# $Id$
# $Log$
# Revision 1.8  2002/09/16 08:08:01  geraint
# Merged changes from global-optimisation branch.
#
# Revision 1.7.2.1  2002/09/04 10:44:59  geraint
# Added option to specify number of tmp variables declared (-ntmpvar <N>).
#
# Revision 1.7  2002/07/10 11:53:32  geraint
# Replaced shell loop with template expansion - perceptibly quicker generation of sympar.h.
#
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
static double ${name}501 MTT_UNUSED;
static double ${name}502 MTT_UNUSED;
static double ${name}503 MTT_UNUSED;
static double ${name}504 MTT_UNUSED;
static double ${name}505 MTT_UNUSED;
static double ${name}506 MTT_UNUSED;
static double ${name}507 MTT_UNUSED;
static double ${name}508 MTT_UNUSED;
static double ${name}509 MTT_UNUSED;
static double ${name}510 MTT_UNUSED;
static double ${name}511 MTT_UNUSED;
static double ${name}512 MTT_UNUSED;
static double ${name}513 MTT_UNUSED;
static double ${name}514 MTT_UNUSED;
static double ${name}515 MTT_UNUSED;
static double ${name}516 MTT_UNUSED;
static double ${name}517 MTT_UNUSED;
static double ${name}518 MTT_UNUSED;
static double ${name}519 MTT_UNUSED;
static double ${name}520 MTT_UNUSED;
static double ${name}521 MTT_UNUSED;
static double ${name}522 MTT_UNUSED;
static double ${name}523 MTT_UNUSED;
static double ${name}524 MTT_UNUSED;
static double ${name}525 MTT_UNUSED;
static double ${name}526 MTT_UNUSED;
static double ${name}527 MTT_UNUSED;
static double ${name}528 MTT_UNUSED;
static double ${name}529 MTT_UNUSED;
static double ${name}530 MTT_UNUSED;
static double ${name}531 MTT_UNUSED;
static double ${name}532 MTT_UNUSED;
static double ${name}533 MTT_UNUSED;
static double ${name}534 MTT_UNUSED;
static double ${name}535 MTT_UNUSED;
static double ${name}536 MTT_UNUSED;
static double ${name}537 MTT_UNUSED;
static double ${name}538 MTT_UNUSED;
static double ${name}539 MTT_UNUSED;
static double ${name}540 MTT_UNUSED;
static double ${name}541 MTT_UNUSED;
static double ${name}542 MTT_UNUSED;
static double ${name}543 MTT_UNUSED;
static double ${name}544 MTT_UNUSED;
static double ${name}545 MTT_UNUSED;
static double ${name}546 MTT_UNUSED;
static double ${name}547 MTT_UNUSED;
static double ${name}548 MTT_UNUSED;
static double ${name}549 MTT_UNUSED;
static double ${name}550 MTT_UNUSED;
static double ${name}551 MTT_UNUSED;
static double ${name}552 MTT_UNUSED;
static double ${name}553 MTT_UNUSED;
static double ${name}554 MTT_UNUSED;
static double ${name}555 MTT_UNUSED;
static double ${name}556 MTT_UNUSED;
static double ${name}557 MTT_UNUSED;
static double ${name}558 MTT_UNUSED;
static double ${name}559 MTT_UNUSED;
static double ${name}560 MTT_UNUSED;
static double ${name}561 MTT_UNUSED;
static double ${name}562 MTT_UNUSED;
static double ${name}563 MTT_UNUSED;
static double ${name}564 MTT_UNUSED;
static double ${name}565 MTT_UNUSED;
static double ${name}566 MTT_UNUSED;
static double ${name}567 MTT_UNUSED;
static double ${name}568 MTT_UNUSED;
static double ${name}569 MTT_UNUSED;
static double ${name}570 MTT_UNUSED;
static double ${name}571 MTT_UNUSED;
static double ${name}572 MTT_UNUSED;
static double ${name}573 MTT_UNUSED;
static double ${name}574 MTT_UNUSED;
static double ${name}575 MTT_UNUSED;
static double ${name}576 MTT_UNUSED;
static double ${name}577 MTT_UNUSED;
static double ${name}578 MTT_UNUSED;
static double ${name}579 MTT_UNUSED;
static double ${name}580 MTT_UNUSED;
static double ${name}581 MTT_UNUSED;
static double ${name}582 MTT_UNUSED;
static double ${name}583 MTT_UNUSED;
static double ${name}584 MTT_UNUSED;
static double ${name}585 MTT_UNUSED;
static double ${name}586 MTT_UNUSED;
static double ${name}587 MTT_UNUSED;
static double ${name}588 MTT_UNUSED;
static double ${name}589 MTT_UNUSED;
static double ${name}590 MTT_UNUSED;
static double ${name}591 MTT_UNUSED;
static double ${name}592 MTT_UNUSED;
static double ${name}593 MTT_UNUSED;
static double ${name}594 MTT_UNUSED;
static double ${name}595 MTT_UNUSED;
static double ${name}596 MTT_UNUSED;
static double ${name}597 MTT_UNUSED;
static double ${name}598 MTT_UNUSED;
static double ${name}599 MTT_UNUSED;
static double ${name}600 MTT_UNUSED;
static double ${name}601 MTT_UNUSED;
static double ${name}602 MTT_UNUSED;
static double ${name}603 MTT_UNUSED;
static double ${name}604 MTT_UNUSED;
static double ${name}605 MTT_UNUSED;
static double ${name}606 MTT_UNUSED;
static double ${name}607 MTT_UNUSED;
static double ${name}608 MTT_UNUSED;
static double ${name}609 MTT_UNUSED;
static double ${name}610 MTT_UNUSED;
static double ${name}611 MTT_UNUSED;
static double ${name}612 MTT_UNUSED;
static double ${name}613 MTT_UNUSED;
static double ${name}614 MTT_UNUSED;
static double ${name}615 MTT_UNUSED;
static double ${name}616 MTT_UNUSED;
static double ${name}617 MTT_UNUSED;
static double ${name}618 MTT_UNUSED;
static double ${name}619 MTT_UNUSED;
static double ${name}620 MTT_UNUSED;
static double ${name}621 MTT_UNUSED;
static double ${name}622 MTT_UNUSED;
static double ${name}623 MTT_UNUSED;
static double ${name}624 MTT_UNUSED;
static double ${name}625 MTT_UNUSED;
static double ${name}626 MTT_UNUSED;
static double ${name}627 MTT_UNUSED;
static double ${name}628 MTT_UNUSED;
static double ${name}629 MTT_UNUSED;
static double ${name}630 MTT_UNUSED;
static double ${name}631 MTT_UNUSED;
static double ${name}632 MTT_UNUSED;
static double ${name}633 MTT_UNUSED;
static double ${name}634 MTT_UNUSED;
static double ${name}635 MTT_UNUSED;
static double ${name}636 MTT_UNUSED;
static double ${name}637 MTT_UNUSED;
static double ${name}638 MTT_UNUSED;
static double ${name}639 MTT_UNUSED;
static double ${name}640 MTT_UNUSED;
static double ${name}641 MTT_UNUSED;
static double ${name}642 MTT_UNUSED;
static double ${name}643 MTT_UNUSED;
static double ${name}644 MTT_UNUSED;
static double ${name}645 MTT_UNUSED;
static double ${name}646 MTT_UNUSED;
static double ${name}647 MTT_UNUSED;
static double ${name}648 MTT_UNUSED;
static double ${name}649 MTT_UNUSED;
static double ${name}650 MTT_UNUSED;
static double ${name}651 MTT_UNUSED;
static double ${name}652 MTT_UNUSED;
static double ${name}653 MTT_UNUSED;
static double ${name}654 MTT_UNUSED;
static double ${name}655 MTT_UNUSED;
static double ${name}656 MTT_UNUSED;
static double ${name}657 MTT_UNUSED;
static double ${name}658 MTT_UNUSED;
static double ${name}659 MTT_UNUSED;
static double ${name}660 MTT_UNUSED;
static double ${name}661 MTT_UNUSED;
static double ${name}662 MTT_UNUSED;
static double ${name}663 MTT_UNUSED;
static double ${name}664 MTT_UNUSED;
static double ${name}665 MTT_UNUSED;
static double ${name}666 MTT_UNUSED;
static double ${name}667 MTT_UNUSED;
static double ${name}668 MTT_UNUSED;
static double ${name}669 MTT_UNUSED;
static double ${name}670 MTT_UNUSED;
static double ${name}671 MTT_UNUSED;
static double ${name}672 MTT_UNUSED;
static double ${name}673 MTT_UNUSED;
static double ${name}674 MTT_UNUSED;
static double ${name}675 MTT_UNUSED;
static double ${name}676 MTT_UNUSED;
static double ${name}677 MTT_UNUSED;
static double ${name}678 MTT_UNUSED;
static double ${name}679 MTT_UNUSED;
static double ${name}680 MTT_UNUSED;
static double ${name}681 MTT_UNUSED;
static double ${name}682 MTT_UNUSED;
static double ${name}683 MTT_UNUSED;
static double ${name}684 MTT_UNUSED;
static double ${name}685 MTT_UNUSED;
static double ${name}686 MTT_UNUSED;
static double ${name}687 MTT_UNUSED;
static double ${name}688 MTT_UNUSED;
static double ${name}689 MTT_UNUSED;
static double ${name}690 MTT_UNUSED;
static double ${name}691 MTT_UNUSED;
static double ${name}692 MTT_UNUSED;
static double ${name}693 MTT_UNUSED;
static double ${name}694 MTT_UNUSED;
static double ${name}695 MTT_UNUSED;
static double ${name}696 MTT_UNUSED;
static double ${name}697 MTT_UNUSED;
static double ${name}698 MTT_UNUSED;
static double ${name}699 MTT_UNUSED;
static double ${name}700 MTT_UNUSED;
static double ${name}701 MTT_UNUSED;
static double ${name}702 MTT_UNUSED;
static double ${name}703 MTT_UNUSED;
static double ${name}704 MTT_UNUSED;
static double ${name}705 MTT_UNUSED;
static double ${name}706 MTT_UNUSED;
static double ${name}707 MTT_UNUSED;
static double ${name}708 MTT_UNUSED;
static double ${name}709 MTT_UNUSED;
static double ${name}710 MTT_UNUSED;
static double ${name}711 MTT_UNUSED;
static double ${name}712 MTT_UNUSED;
static double ${name}713 MTT_UNUSED;
static double ${name}714 MTT_UNUSED;
static double ${name}715 MTT_UNUSED;
static double ${name}716 MTT_UNUSED;
static double ${name}717 MTT_UNUSED;
static double ${name}718 MTT_UNUSED;
static double ${name}719 MTT_UNUSED;
static double ${name}720 MTT_UNUSED;
static double ${name}721 MTT_UNUSED;
static double ${name}722 MTT_UNUSED;
static double ${name}723 MTT_UNUSED;
static double ${name}724 MTT_UNUSED;
static double ${name}725 MTT_UNUSED;
static double ${name}726 MTT_UNUSED;
static double ${name}727 MTT_UNUSED;
static double ${name}728 MTT_UNUSED;
static double ${name}729 MTT_UNUSED;
static double ${name}730 MTT_UNUSED;
static double ${name}731 MTT_UNUSED;
static double ${name}732 MTT_UNUSED;
static double ${name}733 MTT_UNUSED;
static double ${name}734 MTT_UNUSED;
static double ${name}735 MTT_UNUSED;
static double ${name}736 MTT_UNUSED;
static double ${name}737 MTT_UNUSED;
static double ${name}738 MTT_UNUSED;
static double ${name}739 MTT_UNUSED;
static double ${name}740 MTT_UNUSED;
static double ${name}741 MTT_UNUSED;
static double ${name}742 MTT_UNUSED;
static double ${name}743 MTT_UNUSED;
static double ${name}744 MTT_UNUSED;
static double ${name}745 MTT_UNUSED;
static double ${name}746 MTT_UNUSED;
static double ${name}747 MTT_UNUSED;
static double ${name}748 MTT_UNUSED;
static double ${name}749 MTT_UNUSED;
static double ${name}750 MTT_UNUSED;
static double ${name}751 MTT_UNUSED;
static double ${name}752 MTT_UNUSED;
static double ${name}753 MTT_UNUSED;
static double ${name}754 MTT_UNUSED;
static double ${name}755 MTT_UNUSED;
static double ${name}756 MTT_UNUSED;
static double ${name}757 MTT_UNUSED;
static double ${name}758 MTT_UNUSED;
static double ${name}759 MTT_UNUSED;
static double ${name}760 MTT_UNUSED;
static double ${name}761 MTT_UNUSED;
static double ${name}762 MTT_UNUSED;
static double ${name}763 MTT_UNUSED;
static double ${name}764 MTT_UNUSED;
static double ${name}765 MTT_UNUSED;
static double ${name}766 MTT_UNUSED;
static double ${name}767 MTT_UNUSED;
static double ${name}768 MTT_UNUSED;
static double ${name}769 MTT_UNUSED;
static double ${name}770 MTT_UNUSED;
static double ${name}771 MTT_UNUSED;
static double ${name}772 MTT_UNUSED;
static double ${name}773 MTT_UNUSED;
static double ${name}774 MTT_UNUSED;
static double ${name}775 MTT_UNUSED;
static double ${name}776 MTT_UNUSED;
static double ${name}777 MTT_UNUSED;
static double ${name}778 MTT_UNUSED;
static double ${name}779 MTT_UNUSED;
static double ${name}780 MTT_UNUSED;
static double ${name}781 MTT_UNUSED;
static double ${name}782 MTT_UNUSED;
static double ${name}783 MTT_UNUSED;
static double ${name}784 MTT_UNUSED;
static double ${name}785 MTT_UNUSED;
static double ${name}786 MTT_UNUSED;
static double ${name}787 MTT_UNUSED;
static double ${name}788 MTT_UNUSED;
static double ${name}789 MTT_UNUSED;
static double ${name}790 MTT_UNUSED;
static double ${name}791 MTT_UNUSED;
static double ${name}792 MTT_UNUSED;
static double ${name}793 MTT_UNUSED;
static double ${name}794 MTT_UNUSED;
static double ${name}795 MTT_UNUSED;
static double ${name}796 MTT_UNUSED;
static double ${name}797 MTT_UNUSED;
static double ${name}798 MTT_UNUSED;
static double ${name}799 MTT_UNUSED;
static double ${name}800 MTT_UNUSED;
static double ${name}801 MTT_UNUSED;
static double ${name}802 MTT_UNUSED;
static double ${name}803 MTT_UNUSED;
static double ${name}804 MTT_UNUSED;
static double ${name}805 MTT_UNUSED;
static double ${name}806 MTT_UNUSED;
static double ${name}807 MTT_UNUSED;
static double ${name}808 MTT_UNUSED;
static double ${name}809 MTT_UNUSED;
static double ${name}810 MTT_UNUSED;
static double ${name}811 MTT_UNUSED;
static double ${name}812 MTT_UNUSED;
static double ${name}813 MTT_UNUSED;
static double ${name}814 MTT_UNUSED;
static double ${name}815 MTT_UNUSED;
static double ${name}816 MTT_UNUSED;
static double ${name}817 MTT_UNUSED;
static double ${name}818 MTT_UNUSED;
static double ${name}819 MTT_UNUSED;
static double ${name}820 MTT_UNUSED;
static double ${name}821 MTT_UNUSED;
static double ${name}822 MTT_UNUSED;
static double ${name}823 MTT_UNUSED;
static double ${name}824 MTT_UNUSED;
static double ${name}825 MTT_UNUSED;
static double ${name}826 MTT_UNUSED;
static double ${name}827 MTT_UNUSED;
static double ${name}828 MTT_UNUSED;
static double ${name}829 MTT_UNUSED;
static double ${name}830 MTT_UNUSED;
static double ${name}831 MTT_UNUSED;
static double ${name}832 MTT_UNUSED;
static double ${name}833 MTT_UNUSED;
static double ${name}834 MTT_UNUSED;
static double ${name}835 MTT_UNUSED;
static double ${name}836 MTT_UNUSED;
static double ${name}837 MTT_UNUSED;
static double ${name}838 MTT_UNUSED;
static double ${name}839 MTT_UNUSED;
static double ${name}840 MTT_UNUSED;
static double ${name}841 MTT_UNUSED;
static double ${name}842 MTT_UNUSED;
static double ${name}843 MTT_UNUSED;
static double ${name}844 MTT_UNUSED;
static double ${name}845 MTT_UNUSED;
static double ${name}846 MTT_UNUSED;
static double ${name}847 MTT_UNUSED;
static double ${name}848 MTT_UNUSED;
static double ${name}849 MTT_UNUSED;
static double ${name}850 MTT_UNUSED;
static double ${name}851 MTT_UNUSED;
static double ${name}852 MTT_UNUSED;
static double ${name}853 MTT_UNUSED;
static double ${name}854 MTT_UNUSED;
static double ${name}855 MTT_UNUSED;
static double ${name}856 MTT_UNUSED;
static double ${name}857 MTT_UNUSED;
static double ${name}858 MTT_UNUSED;
static double ${name}859 MTT_UNUSED;
static double ${name}860 MTT_UNUSED;
static double ${name}861 MTT_UNUSED;
static double ${name}862 MTT_UNUSED;
static double ${name}863 MTT_UNUSED;
static double ${name}864 MTT_UNUSED;
static double ${name}865 MTT_UNUSED;
static double ${name}866 MTT_UNUSED;
static double ${name}867 MTT_UNUSED;
static double ${name}868 MTT_UNUSED;
static double ${name}869 MTT_UNUSED;
static double ${name}870 MTT_UNUSED;
static double ${name}871 MTT_UNUSED;
static double ${name}872 MTT_UNUSED;
static double ${name}873 MTT_UNUSED;
static double ${name}874 MTT_UNUSED;
static double ${name}875 MTT_UNUSED;
static double ${name}876 MTT_UNUSED;
static double ${name}877 MTT_UNUSED;
static double ${name}878 MTT_UNUSED;
static double ${name}879 MTT_UNUSED;
static double ${name}880 MTT_UNUSED;
static double ${name}881 MTT_UNUSED;
static double ${name}882 MTT_UNUSED;
static double ${name}883 MTT_UNUSED;
static double ${name}884 MTT_UNUSED;
static double ${name}885 MTT_UNUSED;
static double ${name}886 MTT_UNUSED;
static double ${name}887 MTT_UNUSED;
static double ${name}888 MTT_UNUSED;
static double ${name}889 MTT_UNUSED;
static double ${name}890 MTT_UNUSED;
static double ${name}891 MTT_UNUSED;
static double ${name}892 MTT_UNUSED;
static double ${name}893 MTT_UNUSED;
static double ${name}894 MTT_UNUSED;
static double ${name}895 MTT_UNUSED;
static double ${name}896 MTT_UNUSED;
static double ${name}897 MTT_UNUSED;
static double ${name}898 MTT_UNUSED;
static double ${name}899 MTT_UNUSED;
static double ${name}900 MTT_UNUSED;
static double ${name}901 MTT_UNUSED;
static double ${name}902 MTT_UNUSED;
static double ${name}903 MTT_UNUSED;
static double ${name}904 MTT_UNUSED;
static double ${name}905 MTT_UNUSED;
static double ${name}906 MTT_UNUSED;
static double ${name}907 MTT_UNUSED;
static double ${name}908 MTT_UNUSED;
static double ${name}909 MTT_UNUSED;
static double ${name}910 MTT_UNUSED;
static double ${name}911 MTT_UNUSED;
static double ${name}912 MTT_UNUSED;
static double ${name}913 MTT_UNUSED;
static double ${name}914 MTT_UNUSED;
static double ${name}915 MTT_UNUSED;
static double ${name}916 MTT_UNUSED;
static double ${name}917 MTT_UNUSED;
static double ${name}918 MTT_UNUSED;
static double ${name}919 MTT_UNUSED;
static double ${name}920 MTT_UNUSED;
static double ${name}921 MTT_UNUSED;
static double ${name}922 MTT_UNUSED;
static double ${name}923 MTT_UNUSED;
static double ${name}924 MTT_UNUSED;
static double ${name}925 MTT_UNUSED;
static double ${name}926 MTT_UNUSED;
static double ${name}927 MTT_UNUSED;
static double ${name}928 MTT_UNUSED;
static double ${name}929 MTT_UNUSED;
static double ${name}930 MTT_UNUSED;
static double ${name}931 MTT_UNUSED;
static double ${name}932 MTT_UNUSED;
static double ${name}933 MTT_UNUSED;
static double ${name}934 MTT_UNUSED;
static double ${name}935 MTT_UNUSED;
static double ${name}936 MTT_UNUSED;
static double ${name}937 MTT_UNUSED;
static double ${name}938 MTT_UNUSED;
static double ${name}939 MTT_UNUSED;
static double ${name}940 MTT_UNUSED;
static double ${name}941 MTT_UNUSED;
static double ${name}942 MTT_UNUSED;
static double ${name}943 MTT_UNUSED;
static double ${name}944 MTT_UNUSED;
static double ${name}945 MTT_UNUSED;
static double ${name}946 MTT_UNUSED;
static double ${name}947 MTT_UNUSED;
static double ${name}948 MTT_UNUSED;
static double ${name}949 MTT_UNUSED;
static double ${name}950 MTT_UNUSED;
static double ${name}951 MTT_UNUSED;
static double ${name}952 MTT_UNUSED;
static double ${name}953 MTT_UNUSED;
static double ${name}954 MTT_UNUSED;
static double ${name}955 MTT_UNUSED;
static double ${name}956 MTT_UNUSED;
static double ${name}957 MTT_UNUSED;
static double ${name}958 MTT_UNUSED;
static double ${name}959 MTT_UNUSED;
static double ${name}960 MTT_UNUSED;
static double ${name}961 MTT_UNUSED;
static double ${name}962 MTT_UNUSED;
static double ${name}963 MTT_UNUSED;
static double ${name}964 MTT_UNUSED;
static double ${name}965 MTT_UNUSED;
static double ${name}966 MTT_UNUSED;
static double ${name}967 MTT_UNUSED;
static double ${name}968 MTT_UNUSED;
static double ${name}969 MTT_UNUSED;
static double ${name}970 MTT_UNUSED;
static double ${name}971 MTT_UNUSED;
static double ${name}972 MTT_UNUSED;
static double ${name}973 MTT_UNUSED;
static double ${name}974 MTT_UNUSED;
static double ${name}975 MTT_UNUSED;
static double ${name}976 MTT_UNUSED;
static double ${name}977 MTT_UNUSED;
static double ${name}978 MTT_UNUSED;
static double ${name}979 MTT_UNUSED;
static double ${name}980 MTT_UNUSED;
static double ${name}981 MTT_UNUSED;
static double ${name}982 MTT_UNUSED;
static double ${name}983 MTT_UNUSED;
static double ${name}984 MTT_UNUSED;
static double ${name}985 MTT_UNUSED;
static double ${name}986 MTT_UNUSED;
static double ${name}987 MTT_UNUSED;
static double ${name}988 MTT_UNUSED;
static double ${name}989 MTT_UNUSED;
static double ${name}990 MTT_UNUSED;
static double ${name}991 MTT_UNUSED;
static double ${name}992 MTT_UNUSED;
static double ${name}993 MTT_UNUSED;
static double ${name}994 MTT_UNUSED;
static double ${name}995 MTT_UNUSED;
static double ${name}996 MTT_UNUSED;
static double ${name}997 MTT_UNUSED;
static double ${name}998 MTT_UNUSED;
static double ${name}999 MTT_UNUSED;
static double ${name}1000 MTT_UNUSED;
EOF

    if [ ${NUM_OF_TMP_VAR} -gt 1000 ]; then
	i=1001
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
if [ ${NUM_OF_TMP_VAR} -gt 0 ]; then
    declare_temp_vars	>> ${OUT}
fi


