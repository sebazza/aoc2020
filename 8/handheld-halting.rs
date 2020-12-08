// Handheld halting

use std::env;
use std::fs;
use std::str::FromStr;

#[derive(Debug)] // Provides formatting specifier for enum.
enum Operation {NOP, ACC, JMP}

struct Instruction {
    op: Operation,
    value: i32,
    already_executed: bool,
}

// Create operation from string representation.
impl FromStr for Operation {
    type Err = ();
    fn from_str(input: &str) -> Result<Operation, Self::Err> {
        match input {
            "nop" => Ok(Operation::NOP),
            "acc" => Ok(Operation::ACC),
            "jmp" => Ok(Operation::JMP),
            _ => Err(()),
        }
    }
}



fn main() {

    let args: Vec<String> = env::args().collect();


    let mut program = read_file(&args[1]);

    println!("Read {} instructions", program.len());


    execute_program_until_repeat(&mut program);

    program = read_file(&args[1]); // Reread input.

    repair_program(&mut program);
}




// Read file and return parsed content as program.
fn read_file(filename : &String) -> Vec<Instruction> {

    let content = fs::read_to_string(filename)
        .expect("Error reading file");
    
    println!("{}", content);

    let mut program: Vec<Instruction> = Vec::new();
    for line in content.split("\n") {
        if line.len() > 0 {
            let p: Vec<&str> = line.split(" ").collect();
            let o: Operation = Operation::from_str(p[0]).unwrap();
            let v: i32 = p[1].parse().unwrap();
            let instruction = Instruction {op: o, value: v, already_executed: false};
            program.push(instruction);
        }
    }
    program
}


// Part one: Executes instructions until one repeats, prints accumulator value at that point.
fn execute_program_until_repeat(program: &mut [Instruction]) {

    let mut accumulator: i32 = 0;
    let mut instr_pointer: isize = 0;

    loop {
        let mut instruction =  & mut program[instr_pointer as usize];
        println!("{:?} {}", instruction.op, instruction.value);
        if instruction.already_executed == true {
            break;
        }
        match instruction.op {
            Operation::NOP => {
                instr_pointer += 1;
            },
            Operation::ACC => {
                accumulator += instruction.value;
                instr_pointer += 1;
            },
            Operation::JMP => {
                instr_pointer += instruction.value as isize;
            },
        }
        instruction.already_executed = true;
    }

    println!("{}", accumulator);
}




// Part two: Repair corrupt program, prints accumulator after executing repaired program.
fn repair_program(program: &mut [Instruction]) {

    let line_count: isize = program.len() as isize;
    println!("line count = {}", line_count);
    for corruption_pointer in  0..program.len() as usize {
        
        let mut corrupt_instruction = & mut program[corruption_pointer as usize];
        // println!("Corrupt {:?} {}", corrupt_instruction.op, corrupt_instruction.value);
        // Swap JMP and NOP instruction.
        match corrupt_instruction.op {
            Operation::NOP => {
                corrupt_instruction.op = Operation::JMP;
            },
            Operation::ACC => {
                continue; // 
            },
            Operation::JMP => {
               corrupt_instruction.op = Operation::NOP;
            },
        }

        let mut instr_pointer: isize  = 0;
        let mut accumulator: i32 = 0;
        // Reset all executed flags to false.
        for i in 0..program.len() as usize {
            let mut p = &mut program[i];
            p.already_executed = false;
        }
        // Execute program.
        loop {
            if instr_pointer == line_count {
                println!("Repaired");
                break;
            }
            let mut instruction =  & mut program[instr_pointer as usize];
            //println!("{:?} {}", instruction.op, instruction.value);
            if instruction.already_executed == true {
                instruction.already_executed = false; //println!("{:?} {} already executed", instruction.op, instruction.value);
                break;
            }
            match instruction.op {
                Operation::NOP => {
                    instr_pointer += 1;
                },
                Operation::ACC => {
                    accumulator += instruction.value;
                    instr_pointer += 1;
                },
                Operation::JMP => {
                    instr_pointer += instruction.value as isize;
                },
            }
            instruction.already_executed = true;
        }
        if instr_pointer == line_count {
            println!("{}", accumulator);
            break;
        }
        // Restore original operation.
        let mut restore_instruction = & mut program[corruption_pointer as usize];
        //println!("Restore {:?} {}", restore_instruction.op, restore_instruction.value);
        match restore_instruction.op {
            Operation::NOP => {
                restore_instruction.op = Operation::JMP;
            },
            Operation::ACC => {
                continue;
            },
            Operation::JMP => {
                restore_instruction.op = Operation::NOP;
            },
        }
    }
   
}