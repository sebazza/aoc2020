#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef enum {false, true} bool;

typedef struct boarding_pass {
    char * seat;
    int id;
    struct boarding_pass* next;
} boarding_pass;

typedef struct boarding_pass_list {
    struct boarding_pass* boarding_pass;
    struct boarding_pass* first_boarding_pass;
    int min_id;
    int max_id;
} boarding_pass_list;


void print_boarding_pass(boarding_pass *);
void iterate_list(struct boarding_pass_list *list, void (*fp)(boarding_pass *));
int reduce_list(struct boarding_pass_list *list, int (*fp)(boarding_pass *));
void read_input(char*, struct boarding_pass_list *);
void print_list(struct boarding_pass_list *);
int calculate_seat_id(char*);
int find_highest(struct boarding_pass_list *);
int find_my_seat(struct boarding_pass_list *);
bool is_in_list(struct boarding_pass_list *, int);
int check_highest(boarding_pass *bp);



int main(int argv, char** argc) {


    struct boarding_pass_list* list = (boarding_pass_list *) malloc(sizeof(boarding_pass_list));

    read_input("input.txt", list);

    // print_list(list);

    int highest = find_highest(list);

    printf("Highest seat ID is %d\n", highest); 

    find_my_seat(list);
}


int check_highest(boarding_pass *bp) {
    static int highest = 0;

    if (bp->id > highest) {
        highest = bp->id;
    }
    return highest;
}

int find_highest(struct boarding_pass_list *list) {

    int highest = reduce_list(list, check_highest);
    return highest;
}



int calculate_seat_id(char *code) {
    int lower_row = 0;
    int upper_row = 127;
    int lower_col = 0;
    int upper_col = 7;
    // Row
    for (int i = 0; i < 7; i++) {
        switch (code[i]) {
            case 'B': // upper half
                lower_row = lower_row + ((upper_row - lower_row + 1) / 2);
                break;
            case 'F': // lower_row half
                upper_row = upper_row - ((upper_row - lower_row + 1) / 2);
                break;
        }
    }
    //printf("%d %d", lower_row, upper_row);

    // Col (different algo.)
    int half_size = 4;
    int column = 0;
    for (int i = 7; i < 11; i ++) {
        switch(code[i]) {
            case 'L':
            break;
            case 'R':
            column = column + half_size;
            break;
        }
        half_size = half_size / 2;
    }

    return (upper_row * 8) + column;
}




// Read and parse input. 
void read_input(char *file, struct boarding_pass_list* boarding_pass_list) {

    size_t max_line = 20;
    FILE *fp = fopen(file, "r");
    if (boarding_pass_list != NULL) {
        if (fp != NULL) {
            printf("Reading file %s\n", file);
            char *line = malloc(sizeof(char) * 20);
            bool is_first = true;
            boarding_pass* prev = NULL;
            while (fgets(line, max_line, fp) != NULL) {
                boarding_pass* bp = (boarding_pass*) malloc(sizeof(boarding_pass));
                int l = strlen(line);
                char * seat = (char *)  malloc(l);
                strncpy(seat, line, l);
                bp->seat = seat;
                bp->next = NULL;
                bp->id = calculate_seat_id(bp->seat);
                if (boarding_pass_list->min_id > bp->id) {
                    boarding_pass_list->max_id = bp->id;
                }
                if (boarding_pass_list->max_id < bp->id) {
                    boarding_pass_list->max_id = bp->id;
                }
                if (is_first) {
                    boarding_pass_list->first_boarding_pass = bp;
                    is_first = false;
                } else {
                    prev->next = bp;
                }
                prev = bp;
            }
            fclose(fp);
            printf("Finished reading file\n");
        } else {
            printf("No such file.\n");
        }
    } else {
        printf("Bad list");
    }
}


// Perform reduce on list
int reduce_list(struct boarding_pass_list *list, int (*fp)(boarding_pass *)) {
    int result = 0;
    if (list != NULL) {
        boarding_pass *bp = list->first_boarding_pass;
        while (bp != NULL) {
            result = (*fp)(bp);
            bp = bp->next;
        }
    }
    return result;
}

// Iterate over list
void iterate_list(struct boarding_pass_list *list, void (*fp)(boarding_pass *)) {

    if (list != NULL) {
        boarding_pass *bp = list->first_boarding_pass;
        while (bp != NULL) {
            (*fp)(bp);
            bp = bp->next;
        }
    }
}

void print_boarding_pass(boarding_pass *bp) {
    printf("%s %d", bp->seat, bp->id);
}

void print_list(struct boarding_pass_list *list) {

    iterate_list(list, print_boarding_pass);
}


int find_min_seat_id(struct boarding_pass_list *list) {
    int min = (127 * 8) + 7;
    if (list != NULL) {
        boarding_pass *bp = list->first_boarding_pass;
        while (bp != NULL) {
            if (bp->id < min) {
                min = bp->id;
            }
            bp = bp->next;
        }
    } else {
        printf("No such list");
    }
    return min;
}

int find_max_seat_id(struct boarding_pass_list *list) {
    int max = 0;
    if (list != NULL) {
        boarding_pass *bp = list->first_boarding_pass;
        while (bp != NULL) {
            if (bp->id > max) {
                max = bp->id;
            }
            bp = bp->next;
        }
    } else {
        printf("No such list");
    }
    return max;
}



int find_my_seat(struct boarding_pass_list *list) {

    if (list != NULL) {
        for (int i=list->min_id; i < list->max_id; i++) {
            if (!is_in_list(list, i)) {
                // Check 
                if (is_in_list(list, i + 1) && is_in_list (list, i - 1)) {
                    printf ("Found it: %d\n", i);
                    return i;
                }
            }
        }
    } else {
        printf("No such list");
    }

    return 0;
}


bool is_in_list(boarding_pass_list *list, int id) {
    if (list != NULL) {
        boarding_pass *bp = list->first_boarding_pass;
        while (bp != NULL) {
            if (bp->id == id) {
               return true;
            }
            bp = bp->next;
        }
    } else {
        printf("No such list");
    }
    return false;
}
