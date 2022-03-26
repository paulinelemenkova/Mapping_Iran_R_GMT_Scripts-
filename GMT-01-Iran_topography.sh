#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO 15 arc sec global data set (here: Iran)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,0,dimgray \
    FONT_LABEL=7p,0,dimgray \
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Extract a subset of ETOPO1m for the Iceland area
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R43/65/24/40 -Gir_relief.nc
gmt grdcut GEBCO_2019.nc -R43/65/24/40 -Gir_relief.nc
gdalinfo -stats ir_relief.nc
# Minimum=-3487.000, Maximum=5149.000

# Make color palette
gmt makecpt -Cgeo.cpt -V -T-3549/7966 > myocean.cpt

ps=Topo_IR.ps
# Make raster image
gmt grdimage ir_relief.nc -Cmyocean.cpt -R43/65/24/40 -JM6.5i -I+a15+ne0.75 -Xc -K > $ps

# Add legend
gmt psscale -Dg40.5/24.0+w14.0c/0.15i+v+o0.3/0i+ml -R -J -Cmyocean.cpt \
	--FONT_LABEL=7p,0,black \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_TITLE=6p,0,black \
	-Bg500f50a500+l"Color scale: geo [R=-3487/5149, H=0, C=HSV]" \
	-I0.2 -By+lm -O -K >> $ps
    
# Add shorelines
gmt grdcontour ir_relief.nc -R -J -C1000 -W0.1p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thickest,red -W0.1p -Df -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=wESN \
    --MAP_TITLE_OFFSET=1.0c \
    --FONT_ANNOT_PRIMARY=7p,0,black \
    --FONT_LABEL=7p,0,black \
    --FONT_TITLE=12p,0,black \
    -Bpxg4f1a2 -Bpyg2f1a2 -Bsxg2 -Bsyg1 \
    -B+t"Topographic map of Iran with general location (insert global map)" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,0,black \
    --FONT_ANNOT_PRIMARY=6p,0,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Lx14.5c/-1.3c+c50+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/-15p/-38p -O -K >> $ps

gmt psbasemap -R -J \
    --FONT_TITLE=7p,0,white \
    --MAP_TITLE_OFFSET=0.1c \
    -Tdx15.0c/0.4c+w0.3i+f2+l+o0.15i \
    -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,26,blue+jLB >> $ps << EOF
50.0 38.5 Caspian Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,white+jLB >> $ps << EOF
59.4 24.4 Gulf of Oman
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-53 >> $ps << EOF
50.0 28.5 P e r s i a n  G u l f
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-324 >> $ps << EOF
54.3 25.3 Strait of
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,26,blue1+jLB+a-80 >> $ps << EOF
56.7 26.0 Hormuz
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,white+jLB >> $ps << EOF
44.5 32.2 I R A Q
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,white+jLB >> $ps << EOF
43.5 27.0 S A U D I  A R A B I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,black+jLB -Gwhite@40 -Wthinnest >> $ps << EOF
61.0 32.5 AFGHANISTAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,25,black+jLB -Gwhite@40 -Wthinnest >> $ps << EOF
53.0 33.2 I R A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,black+jLB -Gwhite@40 -Wthinnest >> $ps << EOF
62.5 28.7 PAKISTAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,white+jLB >> $ps << EOF
56.1 39.1 TURKMENISTAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,black+jLB -Gwhite@40 -Wthinnest >> $ps << EOF
46.0 39.5 AZERBAIJAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,black+jLB -Gwhite@40 -Wthinnest >> $ps << EOF
44.0 39.5 ARMENIA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,white+jLB+a-273 >> $ps << EOF
51.3 24.7 QATAR
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,black+jLB+a-270 -Gwhite@40 -Wthinnest >> $ps << EOF
43.5 38.0 TURKEY
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,white+jLB >> $ps << EOF
54.5 24.2 U.A.E.
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,white+jLB+a-55 >> $ps << EOF
56.1 24.8 OMAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,0,white+jLB+a-50 >> $ps << EOF
47.1 29.8 KUWAIT
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
51.2 35.2 Tehran
EOF
gmt psxy -R -J -Sg -W0.5p -Gyellow -O -K << EOF >> $ps
51.0 35.0 0.20c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
59.0 35.6 Mashhad
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
59.0 36.0 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
51.2 32.2 Isfahan
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
51.0 32.0 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
54.2 31.2 Yazd
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
54.0 31.0 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
46.2 38.2 Tabriz
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
46.0 38.0 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
52.2 28.8 Shiraz
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
52.0 29.0 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,13,black+jLB -Gwhite@30 >> $ps << EOF
60.2 29.2 Zahedan
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
60.0 29.0 0.15c
EOF
#
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,3,yellow+jLB+a-47 -Gwhite@70 >> $ps << EOF
48.3 34.5 Z a g r o s
51.3 31.7 M o u n t a i n s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB+a-20 -Gwhite@30 >> $ps << EOF
49.5 36.8 E l b u r z
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB+a-30 -Gwhite@30 >> $ps << EOF
57.0 37.5 K ö p e t  D a g
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,0,brown+jLB -Gwhite@30 >> $ps << EOF
54.0 34.2 G r e a t
55.8 32.8 S a l t
57.4 31.2 D e s e r t
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,white+jLB+a-55 >> $ps << EOF
46.2 32.1 Tigris
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,0,white+jLB+a-15 >> $ps << EOF
45.0 30.8 Euphrates
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB -Gwhite@30 -Wthinnest>> $ps << EOF
59.0 26.4 M  a  k  r  a  n
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB >> $ps << EOF
53.8 34.6 Dasht-e Kavir
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,2,brown+jLB+a-60 >> $ps << EOF
58.2 30.8 Dasht-e Lut
EOF

# insert map
# Countries codes: ISO 3166-1 alpha-2. Continent codes AF (Africa), AN (Antarctica), AS (Asia), EU (Europe), OC (Oceania), NA (North America), or SA (South America). -EEU+ggrey
gmt psbasemap -R -J -O -K -DjTR+w3.2c+o-0.2c/-0.2c+stmp >> $ps
read x0 y0 w h < tmp
gmt pscoast --MAP_GRID_PEN_PRIMARY=thin,grey -Rg -JG54/32N/$w -Da -Glightgoldenrod1 -A5000 -Bga -Wfaint -EIR+gred -Sdodgerblue -O -K -X$x0 -Y$y0 >> $ps
gmt psxy -R -J -O -K -T  -X-${x0} -Y-${y0} >> $ps

# Add GMT logo
gmt logo -Dx7.0/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y9.1c -N -O \
    -F+f10p,0,black+jLB >> $ps << EOF
3.0 9.0 Digital elevation data: SRTM/GEBCO, 15 arc sec resolution grid
EOF

# Convert to image file using GhostScript
gmt psconvert Topo_IR.ps -A0.2c -E720 -Tj -Z
