# 2hz-free-behavior-analysis-code

This is basic code to analyze 2hz egg laying tracking. It can obviously be used for tracking at other speeds (may need to change some fixed parameters in the code). 

Typical use would be to first assemble the data:

[eggs, trx] = assemble_data_global(trx, egg, substrate, 0, 'standard', 30, inf);

This takes the "trx" from Ctrax and a matrix of eggs (each column is filled with the egg-laying frame times of the corresponding fly in trx) and creates a new "trx" as well as a egg" structure. These structures have a lot of parameters about each individual egg that are calculated from the data. One of the more complicated plots to make with this data is the "rate plot". Common call to make the rate plot is:

[bincenters, rate0, rate200, rate500, eb0, eb2, eb5] = makerate(eggs, trx, title_string, [0:5:30,45,60, 90, 120, 240, 360, 600, 1200, 7200], 'eggtime', 0, 1,0,length([0:5:30,45,60, 90, 120, 240, 360, 600, 1200, 7200])-1);


See streamlined_analysis.m" for random snippetts of code that can give you an idea of the plots you can generate after creating the "egg" and "trx" data structure.

Note that there are many different versions of "assemble_data_global". These different versions are calculating parameters slightly differently. I have not properly documented them. Stick to the original function unless you figure out what is different with the other versions.

Note that "make_rate" has another version "make_rate2"

"make_rate2" specificallt looks at rates on 200 or 500 mM sucrose since the last visit to 0mM. Rates on 0mM are computed as in the old function. 

The "egg_annotator_gui" is a GUI to help annotate eggs in movies. For details see Nuclino. Tracking Flies -> Identyfying egg laying events -> Annotation GUI.
