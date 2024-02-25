#include <iostream>
#include <fstream>

struct Set {
	int value = 0;
	int *addr = nullptr;
	int timeAcess = 0;
	bool dirtyBit = false;
};

struct Block {
	Set *sets = nullptr;
};

void printCache(Block *cache, int numBlocks, int numSets, int memorySize, int numHits) {
	std::cout << "Cache ";

	if (numBlocks == 1)
		std::cout << "direct mapping\n";
	else if (numSets == 1)
		std::cout << "fully associative\n";
	else
		std::cout << "set associative\n";

	std::cout << "\nBlocos\t\tSets\n";

	int numDirtyBit = 0;

	for (int i = 0; i < numBlocks; i++) {
		std::cout << i << "\t\t";
		for (int j = 0; j < numSets; j++) {
			std::cout << cache[i].sets[j].value << "	";
			if (cache[i].sets[j].dirtyBit)
				numDirtyBit++;
		}
		std::cout << "\n";
	}

	std::cout << "Memory size:"   << memorySize << "\n";
	std::cout << "Hits: "         << numHits << "\n";
	std::cout << "Misses: "       << memorySize - numHits << "\n";
	std::cout << "Hit Rate: "     << (double)numHits / (memorySize)*100 << "%\n";
	std::cout << "Dirty Bits: "   << numDirtyBit << "\n\n";
}

bool powerOfTwo(int x) {
	return x * (!(x & (x - 1)));
}

int wordCount(const std::string &path) {
	std::ifstream file(path);
	int count = 0;
	int temp;
	while (file >> temp) // Read word into temp
		count++;
	file.close();
	return count;
}

int *freshMemory(int size) {
	int *array = new int[size];
	for (int i = 0; i < size; i++)
		array[i] = 0;
	return array;
}

int *loadFileToMemory(const std::string &path, int memorySize) {
	int  *memory = freshMemory(memorySize);
	FILE *file   = fopen(path.c_str(), "r");

	if (file == NULL) {
		delete [] memory;
		std::cerr << "Unable to open file: '"<< path <<"'\n";
		throw std::runtime_error("IOError");
	}

	std::cout << "Loading '"<< path << "'...\n";
	for (int i = 0; i < memorySize; i++)
		fscanf(file, "%d", &memory[i]);

	fclose(file);
	return memory;
}

Block *createCache(int numBlocks, int numSets) {
	Block *cache = new Block[numBlocks];
	for (int i = 0; i < numBlocks; i++)
		cache[i].sets = new Set[numSets];
	return cache;
}

Block *sortCache(Block *cache, int numBlocks, int numSets) {
	for (int i = 0; i < numBlocks; i++) {
		for (int j = 0; j < numSets; j++) {
			for (int k = 0; k < numSets - 1; k++) {
				if (cache[i].sets[k].timeAcess > cache[i].sets[k + 1].timeAcess) {
					Set temp = cache[i].sets[k];
					cache[i].sets[k] = cache[i].sets[k + 1];
					cache[i].sets[k + 1] = temp;
				}
			}
		}
	}
	return cache;
}

bool isCacheValue(Block *cache, int blockIndex, int numSets, int memoryValue, int timeAcess) {
	for (int i = 0; i < numSets; i++) {
		if (cache[blockIndex].sets[i].value == memoryValue) {
			cache[blockIndex].sets[i].timeAcess = timeAcess;
			return true;
		}
	}
	return false;
}

void simulateCache(const std::string &dataFilePath, int numBlocks, int numSets) {
	int memorySize = wordCount(dataFilePath);
	int *memory    = loadFileToMemory(dataFilePath, memorySize);
	Block *cache   = createCache(numBlocks, numSets);

	int numHits = 0;
	int timeAcess = 0;

	for (int i = 0; i < memorySize; i++) {
		int memoryValue = memory[i];
		int blockIndex = memoryValue % numBlocks;
		int *cacheValue = &cache[blockIndex].sets[0].value;

		if (isCacheValue(cache, blockIndex, numSets, memoryValue, timeAcess) && i != 0) {
			numHits++;
		}
		else {
			cache[blockIndex].sets[0].value = memoryValue;
			cache[blockIndex].sets[0].addr = &memory[i];
			cache[blockIndex].sets[0].timeAcess = timeAcess;
			cache[blockIndex].sets[0].dirtyBit = true;
		}

		cache = sortCache(cache, numBlocks, numSets);
		timeAcess++;
	}

	printCache(cache, numBlocks, numSets, memorySize, numHits);

	for (int i = 0; i < numBlocks; i++)
		delete[] cache[i].sets;
	delete[] cache;
	delete[] memory;
}

int queryUserBlocks(){
	int numBlocks = 0;
	while (true) {
		std::cout << "Enter the number of blocks: ";
		std::cin >> numBlocks;
		if (powerOfTwo(numBlocks))
			break;
		std::cout << "The number of sets must be a power of two\n";
	}
	return numBlocks;
}

int queryUserSets(){
	int numSets = 0;

	while (true) {
		std::cout << "Enter the number of sets: ";
		std::cin >> numSets;
		if (powerOfTwo(numSets))
			break;
		std::cout << "The number of sets must be a power of two\n";
	}
	return numSets;
}

std::string queryUserFile(){
	std::string filePath;
	std::cout << "Enter file to load data from (type - for default): ";
	std::cin >> filePath;
	if(filePath[0] == '-')
		filePath = "data.txt";
	return filePath;
}

int main(int argc, const char** argv) {
	char menuOpt = 0;
	const char* path = argv[1];
	while (true) {
		std::cout << "- (s)imulate cache\n- (q)uit\n>  ";
		std::cin >> menuOpt;
		if(menuOpt == 's'){
			auto blocks = queryUserBlocks();
			auto sets   = queryUserSets();
			auto path   = queryUserFile();
			simulateCache(path, sets, blocks);
		} else if (menuOpt == 'q'){
			return EXIT_SUCCESS;
		} else {
			continue;
		}
	}

	return EXIT_SUCCESS;
}