# ## Makes the table of resonant frequencies

# ## Actual resonant freqs
# fr_measured = [
# 	2.0683e+01
# 	7.5310e+01
# 	1.7080e+02
# 	3.0532e+02
# 	4.7414e+02];

# fa_measured = [
# 	 2.0896e+01
# 	 7.6867e+01
# 	 1.7794e+02
# 	 3.1890e+02
# 	 4.8768e+02];

## Parameters - ideal pinned beam
PinnedBeam_numpar;

## Ideal pinned beam - theory
[fr_theory] = beam_frequencies("pinned",ei,rhoa,beamlength)/(2*pi);
[fa_theory] = beam_frequencies("clamped-pinned",ei,rhoa,beamlength)/(2*pi);

## SM form to get poles and zeros of the model
# ## Ideal pinned
# [A,B,C,D] = PinnedBeam_sm;
# fr_model_ideal  = frequencies(A,B,C,D)/(2*pi);

# ## Actual with non-ideal pins 
# PinnedBeam_numpar;

[A,B,C,D] = PinnedBeam_sm;

[w_r, w_a]  = frequencies(A,B,C,D);
fr_model = w_r/(2*pi);
fa_model = w_a/(2*pi);


printf("\nIndex \t& Theory   \t& Model \t& Theory  \t& Model \\\\ \n");
printf("\\hline\n");
for i = 1:5
  printf("%i \t& %3.2f \t& %3.2f \t& %3.2f  \t& %3.2f\\\\ \n", i, \
	 fr_theory(i), fr_model(i), fa_theory(i), fa_model(i));
endfor

# printf("\nMode \t& Theory   \t& Model(ideal) \t& Model  \t& Actual \\\\ \n");
# printf("\\hline\n");
# for i = 1:5
#   printf("%i \t& %3.2f \t& %3.2f \t& %3.2f  \t& %3.2f\\\\ \n", i, fr_theory(i), \
# 	 fr_model_ideal(i), fr_model(i), fr_measured(i));
# endfor
	 
# printf("\nMode  \t& Theory  \t& Model  \t& Actual \\\\ \n");
# printf("\\hline\n");
# for i = 1:5
#   printf("%i \t& %3.2f \t& %3.2f \t& %3.2f \\\\ \n", i, fa_theory(i), fa_model(i), fa_measured(i));
# endfor
	





