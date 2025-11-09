print("""VERSION 5.7 ;
DIVIDERCHAR "/" ;
BUSBITCHARS "[]" ;
DESIGN shifter1 ;
UNITS DISTANCE MICRONS 1000 ;
DIEAREA ( 0 0 ) ( 60000 100000 ) ;""")
for row in range(22):
    print(f"""ROW ROW_{row} CoreSite 6000  {6000+row*4000} N DO 40 BY 1 STEP 1000 0 ;""")
trackStep = 50
trackCount = 2000
for m in range(1,4):
    print(f"""TRACKS X 0 DO {trackCount} STEP {trackStep} LAYER M{m} ;
TRACKS Y 0 DO {trackCount} STEP {trackStep} LAYER M{m} ;
    """)
print("""PINS 0 ;""")
x = 55000
y = 67500
pinDimension=300
pinRect = f"( {-pinDimension/2} {-pinDimension/2} ) ( {pinDimension/2} {pinDimension/2} )"
print(f"""- A0 + NET XXX 
 + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
y = y - 500
print(f"""- rev1 + NET XXX 
 + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
y = y - 500
print(f"""- rev1_n + NET XXX 
 + USE SIGNAL + PORT + LAYER M1 {pinRect} + FIXED ( {x} {y} ) E ;""")
y = y - 500
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
print("""END PINS
END DESIGN""")

