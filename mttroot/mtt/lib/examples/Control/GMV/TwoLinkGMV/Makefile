# Makefile for the Two link GMV example

all: msdp_tf.m twolinkp_obs.m twolinkp_sm.m TwoLinkGMV_numpar.m 

msdP_tf.m: msdP_abg.fig 
	mtt -q msdP tf m

msdp_tf.m: msdP_tf.m
	tr [A-Z] [a-z] <msdP_tf.m >msdp_tf.m

TwoLinkP_obs.m: TwoLinkP_abg.fig TwoLinkP_lbl.txt
	mtt -q TwoLinkP obs m

twolinkp_obs.m: TwoLinkP_obs.m
	tr [A-Z] [a-z] <TwoLinkP_obs.m >twolinkp_obs.m

TwoLinkP_sm.m: TwoLinkP_abg.fig TwoLinkP_lbl.txt
	mtt -q TwoLinkP sm m

twolinkp_sm.m: TwoLinkP_sm.m
	tr [A-Z] [a-z] <TwoLinkP_sm.m >twolinkp_sm.m

TwoLinkGMV_numpar.m: TwoLinkGMV_numpar.txt
	mtt -q TwoLinkGMV numpar m

