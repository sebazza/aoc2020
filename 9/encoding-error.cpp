#include <iostream>
#include <fstream>
#include <string>
#include <vector>


void read_file(std::string, std::vector<unsigned long long> *);
bool check_sum(unsigned long long, std::vector<unsigned long long> *);
unsigned long long find_weakness(unsigned long long, std::vector<unsigned long long> *);

int main(int argc, char* argv[]) {

    std::vector<unsigned long long> number_list;
    std::vector<unsigned long long> preamble;
    std::string filename (argv[1]);

    int preamble_size = 25;

    // Read input numbers.
    read_file(filename, &number_list);
    std::cout << "Size of number list is " << number_list.size() << std::endl;
    // Copy preamble.
    std::vector<unsigned long long>::iterator end = number_list.begin() + preamble_size;
    preamble.assign(number_list.begin(), end);
    // Remove preamble from number list.
    //number_list.erase(number_list.begin(), number_list.begin() + preamble_size);

    std::cout << "Size of preamble list is " << preamble.size() << std::endl;

    // Loop through numbers, check each can be a sum of two preamble numbers.
    for (auto it = number_list.begin() + preamble_size; it != number_list.end(); ++it) {
        unsigned long long number = *it;
        bool valid = check_sum(number, &preamble);
        //std::cout << number << " is " << (valid ? "valid": "invalid") << std::endl;
        if (!valid) {
            // Find weakness from invalid number.
            unsigned long long weakness = find_weakness(number, &number_list);
            std::cout << weakness << std::endl;
            break;
        }
        preamble.push_back(number);
        preamble.erase(preamble.begin());
    }


}




// Read and parse input file into vector.
void read_file(std::string filename, std::vector<unsigned long long> *numbers) {

    std::ifstream ifs;
    ifs.open(filename, std::ifstream::in);
    std::string line;
    while (ifs.good()) {
        std::getline(ifs, line);
        try {
           unsigned long long number = std::stoull(line, nullptr, 0);
           numbers->push_back(number);
        } catch (const std::invalid_argument& ia) {
            std::cout << "Invalid input: " << line << " is not a number" << std::endl;
        }
        
    }
}


// Check number is sum of two preamble numbers.
bool check_sum(unsigned long long number, std::vector<unsigned long long> *preamble) {

    for (auto it = std::begin(*preamble); it != std::end(*preamble); ++it) {
        unsigned long long n = *it;
        for (auto iit = it; iit != std::end(*preamble); ++iit) {
            if (n + *iit == number) {
                return true;
            }
        }
       
    }
    return false;
}



// Find contiguous string of numbers that add to invalid number, weakness is the sum of
// the maximun and minimum.
unsigned long long find_weakness(unsigned long long number, std::vector<unsigned long long> *number_list) {

    unsigned long long weakness;
    std::vector<unsigned long long> contiguous_numbers;
    for (auto it = std::begin(*number_list); it != std::end(*number_list); ++it) {
        unsigned long long n = *it;
        unsigned long long sum = n;
        contiguous_numbers.push_back(n);
        for (auto iit = it + 1; iit != std::end(*number_list); ++iit) {
            contiguous_numbers.push_back(*iit);
            sum += *iit;
            if (sum > number) {
                break;
            }
            if (sum == number) {
                std::cout << "Found weakness: ";
                for (auto v : contiguous_numbers) {
                    std::cout << v << " ";
                }
                std::cout << std::endl;
                //
                unsigned long long maximum =
                    *(max_element(std::begin(contiguous_numbers), std::end(contiguous_numbers)));
                unsigned long long minimum =
                    *(min_element(std::begin(contiguous_numbers), std::end(contiguous_numbers))); 
                weakness = minimum + maximum;
                break;
            }

        }
        contiguous_numbers.clear();
    
    }
    return weakness;

}