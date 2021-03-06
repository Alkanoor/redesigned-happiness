OBJ_DIR = obj
SRC_DIR = .
SRC1 = regular.cpp
OBJ1 := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(notdir $(SRC1)))
SRC2 = archimede.cpp util.cpp
OBJ2 := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(notdir $(SRC2)))
SRC3 = polyhedron_topology.cpp shining.cpp faces_graph.cpp util.cpp
OBJ3 := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(notdir $(SRC3)))
VPATH=.

RELEASE_DIR = bin
TARGET1 = regular
EXEC1 = $(RELEASE_DIR)/$(TARGET1)
TARGET2 = archimede
EXEC2 = $(RELEASE_DIR)/$(TARGET2)
TARGET3 = shining
EXEC3 = $(RELEASE_DIR)/$(TARGET3)

FIRST_STAGE = regular regular_obj
SECOND_STAGE = archimede archimede_json archimede_hashed archimede_obj archimede_hashed/catalan
FINAL_STAGE = shining shining_mqo shining_obj

CC = g++
CFLAGS = -Wall -Werror -O1 -std=c++11
LDFLAGS = -lm -lCGAL -lCGAL_Core -lgmp -std=c++11


all: createDir $(EXEC1) $(EXEC2) $(EXEC3)

$(EXEC1): $(OBJ1)
	$(CC) -o $@ $^ $(LDFLAGS)

$(EXEC2): $(OBJ2)
	$(CC) -o $@ $^ $(LDFLAGS)

$(EXEC3): $(OBJ3)
	$(CC) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: %.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

run: createDir $(EXEC1)
	./$(EXEC1)

run-regular: run

run-archimede: createDir run-regular $(EXEC2)
	./$(EXEC2)

run-shining: createDir run-archimede $(EXEC3)
	./$(EXEC3)

run-archimede-no-depend: createDir $(EXEC2)
	./$(EXEC2)

run-shining-no-depend: createDir $(EXEC3)
	./$(EXEC3)


createDir:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(RELEASE_DIR)
	@mkdir -p $(FIRST_STAGE)
	@mkdir -p $(SECOND_STAGE)
	@mkdir -p $(FINAL_STAGE)

clean :
	@rm -rf $(OBJ_DIR)
	@rm -rf $(RELEASE_DIR)
	@rm -rf $(FIRST_STAGE)
	@rm -rf $(SECOND_STAGE)
	@rm -rf $(FINAL_STAGE)
