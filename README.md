# Agents of Chaos' Embedded Programming project.

## Running the code

The makefile has the following recipes - 

```
all - Compiles all the required files
run - Runs the compiled files
with-gtkwave - Compiles and runs the files, as well as creates the GTKWave file
clean - Cleans up the .o, .cf and executable files from the directory
```
<br />  

---
<br />

## The team is - 

* EE16BTECH11026 - Aravind Ganesh
* ES16BTECH11005 - Jeel Bhavsar
* ES16BTECH11012 - Akshita Ramya
* ES16BTECH11025 - V. V. Shashank
* ES16BTECH11029 - Srinidhi Bachu

##### Here's how you build GHDL for Ubuntu, in case you haven't already - 

We're gonna be building ghdl with a gcc backend. This will take slightly more disk-space (not by much) and a little longer to download the files for, but gcc should be the fastest backend for ghdl. Here we go -  

0. Install an ada compiler (you may already have this, run the command anyway) -  
	`sudo apt-get install gnat`  

1. Acquire gcc source-code. The download is the time taking part.  
	`wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2`

2. After downlaoding the tar.gz archive of the source code, extract it  
	`tar xvjf gcc-4.9.4.tar.bz2`

3. Add the directory of your gcc source code to a local variable -  
	`gccsource=$(pwd)/gcc-4.9.4/`

4. Download certain prerequisites for gcc -  
	`(cd $gccsource; ./contrib/download_prerequisites)`

5. After that's done, download ghdl source code -  
	`git clone https://github.com/tgingold/ghdl.git`

6. Go into the directory where you downloaded ghdl -  
	`cd ghdl`

7. Configure ghdl with the right parameters before install -  
	`./configure --with-gcc=$gccsource --prefix=/usr/local`

8. Finally, install ghdl - 
	```
	make
	sudo make install
	```

9. Yayy! You're done! After you're done, you can get rid of the gcc and ghdl source code you downloaded - 
	```
	cd ..
	sudo rm -R ghdl
	sudo rm -R gcc-4.9.4
	```

Now, you can use ghdl normally as a terminal command to compile and run vhdl files! :D


##### This is how to compile and run a vhdl file

Write a vhdl code in a text file and save it with `.vhdl` file extension. 

In the directory run this command 
	`export PATH=/opt/ghdl-updates/bin/:$PATH`

Run the following command to compile the file
	`ghdl -a file_name.vhdl`

Then you have to build excutable file (`-e` means elaborate)
	`ghdl -e entity_name`

An executable file `entity_name` is generated. To run the file excute the following command
	`ghdl -r entity_name`

#### GTKWave

To install GTKWave, run the following in the terminal
	`sudo apt-get install gtkwave`

Follow this step while running the executable file to create waveform file (VCD format)
	`ghdl -r excutable_file --vcd=file_name.vcd`

To view the `.vcd` file, 
	`gtkwave file_name.vcd` 
