import sys
import sexpdata
import copy
import uuid

inputBoardFile = sys.argv[1]
outputBoardFile = sys.argv[2]

print(f"input: {inputBoardFile}, output: {outputBoardFile}")

def loadFile(file: str):
    with open(file, 'r') as f:
        return sexpdata.load(f)

def saveFile(file: str, sexp):
    with open(file, 'w') as f:
        sexpdata.dump(sexp, f, pretty_print=True)

class KicadObject:
    def __init__(self, sexpr):
        self.__items = []
        self.__itemsByName = None
        self.__deleted = False
        for item in sexpr:
            if type(item) is list and type(item[0]) is sexpdata.Symbol:
                item = KicadObject(item)
            self.__items.append(item)

    def __str__(self):
        return sexpdata.dumps(self)

    def item(self, i):
        return self.__items[i]
    
    # Mark this object as deleted, in which case it won't get returned by the iterator
    def delete(self):
        self.__deleted = True

    def __iter__(self):
        for item in self.__items:
            if not type(item) is KicadObject or not item.__deleted:
                yield(item)

    @property
    def kclass(self):
        return self.__items[0].value()

    def getAttributeByName(self, name):
        if self.__itemsByName == None:
            self.__itemsByName = {}
            for item in self.__items:
                if type(item) is KicadObject:
                    self.__itemsByName.setdefault(item.kclass, []).append(item) 
        return self.__itemsByName[name]

    def __getattr__(self, name):
        return self.getAttributeByName(name)
    
    def clone(self):
        clone = KicadObject([])
        for item in self.__items:
            if type(item) is KicadObject:
                clone.append(item.clone())
            else:
                clone.append(item)
        return clone

    def append(self, obj):
        self.__items.append(obj)
        self.__itemsByName = None

    def shift(self, relativePosition):
        self.__items[1] += relativePosition.__items[1]
        self.__items[2] += relativePosition.__items[2]

    # recursively update all uuid's to combine them with a parent uuid
    def processUUIDs(self, parent):
        if self.kclass == 'uuid':
            self.__items[1] = str(uuid.uuid5(uuid.UUID(parent.uuid[0].__items[1]), self.__items[1]))
            self.__itemsByName = None
        else:
            for item in self.__items:
                if type(item) is KicadObject:
                    item.processUUIDs(parent)
    @property
    def netID(self):
        if not self.kclass == "net":
            raise Exception("Not a net")
        return self.__items[1]
    @property
    def netName(self):
        if not self.kclass == "net":
            raise Exception("Not a net")
        return self.__items[2]
    def resolveNet(self, resolvedNet):
        if not self.kclass == "net":
            raise Exception("Not a net")
        self.__items[1] = resolvedNet.netID
        if len(self.__items) > 2:
            self.__items[2] = resolvedNet.netName

inputBoard = KicadObject(loadFile(inputBoardFile))

cellBoards = {}
cellBoards["RVCMOS:NOT"] = KicadObject(loadFile("../design/Cells/NOT/NOT.kicad_pcb"))
cellBoards["RVCMOS:AOI22"] = KicadObject(loadFile("../design/Cells/AOI22/AOI22.kicad_pcb"))

inputNets = {}
maxNetID = 0
GND = None
VDD = None
for net in inputBoard.net:
    inputNets[net.netID] = net
    maxNetID = max(maxNetID, net.netID)
    if net.netName == "GND":
        GND = net
    if net.netName == "VDD":
        VDD = net

def addBoardNet(name):
    global maxNetID
    net = KicadObject([sexpdata.Symbol("net"), maxNetID + 1, name])
    maxNetID = maxNetID + 1
    inputNets[net.netID] = net
    inputBoard.append(net)
    return net

if GND == None:
    GND = addBoardNet("GND")
if VDD == None:
    VDD = addBoardNet("VDD")

def processCellFootprint(cellBoard, cellFootprint):
    cellFootprint.delete()
    cellRef = None
    for prop in cellFootprint.property:
        if prop.item(1) == "Reference":
            cellRef = prop.item(2)
    cellBoard = cellBoard.clone()
    cellBoard.processUUIDs(cellFootprint)
    padsByName = {}
    for pad in cellFootprint.pad:
        padName = pad.item(1)
        padsByName[padName] = pad
    nets = {}
    for net in cellBoard.net:
        if net.netName in padsByName:
            resolvedNet = inputNets[padsByName[net.netName].net[0].netID]
        elif net.netName == "VDD":
            # Global nets
            resolvedNet = VDD
        elif net.netName == "GND":
            resolvedNet = GND
        else:  
            # Create a new outer net
            resolvedNet = addBoardNet(cellRef + "." + net.netName)
        nets[net.netID] = resolvedNet

    def rewriteNetRef(obj):
        for net in obj.net:
            net.resolveNet(nets[net.netID])

    # Renumber the nets
    for net in nets.values():
        if net.netName in padsByName:
            # Connected to outer net
            net.outerID = padsByName[net.netName].net[0].netID 

    # Cleanup and adapt the sub-board copy
    for footprint in cellBoard.footprint:
        for pos in footprint.at:
            pos.shift(cellFootprint.at[0])
        for pad in footprint.pad:
            rewriteNetRef(pad)
        inputBoard.append(footprint)
    for segment in cellBoard.segment:
            for pos in segment.start:
                pos.shift(cellFootprint.at[0])
            for pos in segment.end:
                pos.shift(cellFootprint.at[0])
            rewriteNetRef(segment)
            inputBoard.append(segment)
        
    for via in cellBoard.via:
        net = nets[via.net[0].netID]
        if net.netName != "":
            for pos in via.at:
                pos.shift(cellFootprint.at[0])
            rewriteNetRef(via)
            inputBoard.append(via)

# Get all of the RVCMOS footprints

for obj in inputBoard:
    if type(obj) is KicadObject and obj.kclass == 'footprint':
        name = obj.item(1)
        if name in cellBoards:
            processCellFootprint(cellBoards[name], obj)

saveFile(outputBoardFile, inputBoard)


# from kiutils.board import Board
# from kiutils.footprint import Footprint
# from kiutils.utils import sexpr

# board = Board().from_file(inputBoard)

# if False:
#     NOT_board = Board().from_file("../design/Cells/NOT/NOT.kicad_pcb")

#     firstDone = False

#     for footprint in board.footprints:
#         if footprint.libraryNickname == 'RVCMOS':
#             if footprint.entryName == 'NOT':
#                 if not firstDone:
#                     firstT = Footprint.from_sexpr(sexpr.parse_sexp(NOT_board.footprints[0].to_sexpr()))
#                     firstT.properties["Reference"] = footprint.properties["Reference"] + "-" + firstT.properties["Reference"]
#                     firstT.position.X += footprint.position.X
#                     firstT.position.Y += footprint.position.Y
#                     for pad in firstT.pads:
#                         pad.net = None
#                     board.footprints.append(firstT)
#                     firstDone = True

# board.to_file(outputBoard)




# # https://stackoverflow.com/a/77256881/1695431
# def repl():
#     """This starts a REPL with the callers globals and locals available

#     Raises:
#         RuntimeError: Is raised when the callers frame is not available
#     """
#     import code
#     import inspect

#     frame = inspect.currentframe()
#     if not frame:
#         raise RuntimeError('No caller frame')

#     code.interact(local=dict(frame.f_back.f_globals, **frame.f_back.f_locals))
    

# repl()

