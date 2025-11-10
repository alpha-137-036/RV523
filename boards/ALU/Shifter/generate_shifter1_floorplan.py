print("""VERSION 5.7 ;
DIVIDERCHAR "/" ;
BUSBITCHARS "[]" ;
DESIGN shifter1 ;
UNITS DISTANCE MICRONS 1000 ;
DIEAREA ( 0 0 ) ( 65000 100000 ) ;""")
rowWidth = 44
for row in range(22):
    print(f"""ROW ROW_{row} CoreSite 6000  {6000+row*4000} N DO {rowWidth} BY 1 STEP 1000 0 ;""")
trackStep = 50
trackCount = 2000
for m in range(1,4):
    print(f"""TRACKS X 0 DO {trackCount} STEP {trackStep} LAYER M{m} ;
TRACKS Y 0 DO {trackCount} STEP {trackStep} LAYER M{m} ;
    """)

# Explicitly place decaps
print("COMPONENTS 22 ;")
for row in range(22):
    print(f"- decap{row}_L DECAP + FIXED ( 6000 {6000+row*4000} ) N ;")
    print(f"- decap{row}_R DECAP + FIXED ( {6000 + (rowWidth-1)*1000} {6000+row*4000} ) N ;")
    middlePosition = rowWidth * 3 // 5 if row % 2 == 0 else rowWidth * 2 // 5
    print(f"- decap{row}_M DECAP + FIXED ( {6000 + middlePosition*1000} {6000+row*4000} ) N ;")
print("END COMPONENTS")
print("""PINS 0 ;""")
x = 60000
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
print("""END PINS""")

print("""END DESIGN""")

