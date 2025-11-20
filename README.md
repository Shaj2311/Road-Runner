# Road Runner

This is a basic game written in 16-bit NASM assembly for the iAPX88 architecture.

## Requirements
To run this project, you need the following:
* NASM (Netwide Assembler)
* 16 Bit DOS Emulator (e.g. DOSBox)

## How to Run 
1. Navigate to the directory where `nasm.exe` is placed, and clone this repository to your machine 
```cmd
cd Path/To/nasm.exe
git clone https://github.com/Shaj2311/Road-Runner.git
```
2. Launch your preferred emulator 
3. Mount the path to `nasm.exe`
4. Assemble using nasm:
```DOS
nasm .\Road-Runner\main.asm -o .\Road-Runner\runner.com
```
5. Once the `.com` file assembles, launch it:
```DOS
.\Road-Runner\runner.com
```
6. Enjoy!
