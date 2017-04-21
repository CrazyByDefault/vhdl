### Agents of Chaos' Embedded Programming project.


##### All code goes into src, all documentation shiz goes into documentation

- Let's not all work on master. Everyone make your branches, work there. After we figure out what's working well and what isn't we'll all jump to master.
- Keep talking about stuff on the WhatsApp group. If you're working on master, after each push, mention it on the group.
- If you have no idea what I've just said, here's a Git tutorial - [click this](https://try.github.io/)

---
<br />

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
	`sudo apt-get install ghdl gtkwave`

Follow this step while running the executable file to create waveform file (VCD format)
	`ghdl -r excutable_file --vcd=file_name.vcd`

To view the `.vcd` file, 
	`gtkwave file_name.vcd` 