print("""VERSION 5.7 ;
DIVIDERCHAR "/" ;
BUSBITCHARS "[]" ;
DESIGN shifter1 ;
UNITS DISTANCE MICRONS 1000 ;
DIEAREA ( 0 0 ) ( 100000 100000 ) ;""")
for row in range(20):
    print(f"""ROW ROW_{row} CoreSite 10000  {10000+row*4000} N DO 64 BY 1 STEP 1000 0 ;""")
print("""TRACKS X 0 DO 1000 STEP 100 LAYER M1 ;
TRACKS Y 0 DO 1000 STEP 100 LAYER M1 ;
TRACKS X 0 DO 1000 STEP 100 LAYER M2 ;
TRACKS Y 0 DO 1000 STEP 100 LAYER M2 ;
TRACKS X 0 DO 1000 STEP 100 LAYER M3 ;
TRACKS Y 0 DO 1000 STEP 100 LAYER M3 ;
TRACKS X 0 DO 1000 STEP 100 LAYER M4 ;
TRACKS Y 0 DO 1000 STEP 100 LAYER M4 ;
PINS 0 ;""")
x = 90000
y = 67500
pinDimension=300
pinRect = f"( {-pinDimension/2} {-pinDimension/2} ) ( {pinDimension/2} {pinDimension/2} )"
for i in range(32):
    print(f"""- A[{i}] + NET XXX 
     + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
    y = y - 500
    print(f"""- F[{i}] + NET XXX 
     + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
    y = y - 500
for i in range(2):
    print(f"""- B[{i}] + NET XXX 
     + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
    y = y - 500
print(f"""- A0 + NET XXX 
 + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
y = y - 500
print(f"""- rev1 + NET XXX 
 + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
y = y - 500
print(f"""- rev1_n + NET XXX 
 + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
y = y - 500
print("""END PINS
END DESIGN""")

