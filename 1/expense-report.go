/**
 *  Advent of code 2020
 *
 * Find the two number on the input that add to 2020. What is their product?
 *
 */

package main

import (
	"fmt"
	"bufio"
	"os"
	"log"
	"strconv"
)


func main()  {

	input_filename := os.Args[1]
	number_list := read_input_file(input_filename)

	// Nested loop to find number pair.
	for i, v := range number_list {
		for j, w := range number_list[i:] {  // Only need to look at numbers from index i onwards
			if  v + w == 2020 {
				// Print product of the two number that add to 2020.
					
				fmt.Printf("Found the two entries (%d, %d) that sum together to 2020. Multiplied together they give %d.\n",  i, j, v * w)
			}
		}
	}

	// Nested loop to find number pair.
	for i, v := range number_list {
		for j, w := range number_list[i:] {  // Only need to look at numbers from index i onwards
		    for k, u := range number_list[j:] {
				if  v + w + u == 2020 {
					// Print product of the two number that add to 2020.
					fmt.Printf("Found the three entries (%d, %d, %d) that sum together to 2020. Multiplied together they give %d.\n",  i, j, k, v * w * u)
				}
			}
		}
	}



}


// Read the input file. File should have one number (as string) per line.
func read_input_file(input_filename string) []uint64 {
	
	file, err := os.Open(input_filename)
	if err != nil {
		log.Fatal(err)
	}

	defer file.Close() //  Love it!! Do this when function return.

	var number_list []uint64
	scanner := bufio.NewScanner(file)
   	for scanner.Scan() {
   		i, err := strconv.ParseUint(scanner.Text(), 10, 64)
   		if err == nil {
   			number_list = append(number_list, i)
   		}
	}

    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }

    return number_list

}




