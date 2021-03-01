#ifndef COMPONENTS_HH
#define COMPONENTS_HH

// $ cd $(echo $MTT_COMPONENTS/simple | sed 's/\.://')
// $ ls *_eqn.m | gawk -F_ '{printf ("%s, ", $1)}'
enum component {
  AE, AF, C, EBTF, EMTF, ES, FMR, FP, GY, I, PS, RST, RS, R, SS, TF,
  ae, af, c, ebtf, emtf, es, fmr, fp, gy, i, ps, rst, rs, r, ss, tf
};

typedef enum component component_t;
  

#endif
