print("\\Clear");
//	MIT License
//	Copyright (c) 2021 Nicholas Condon n.condon@uq.edu.au
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
scripttitle= "Emily_Nuclei_StarDist_Script";
version= "0.1";
date= "03-02-2021";
description= "Finds Nuclei & Measures Red/Green Intensity";
showMessage("Institute for Molecular Biosciences ImageJ Script", "<html>
    +"<h1><font size=6 color=Teal>ACRF: Cancer Biology Imaging Facility</h1>
    +"<h1><font size=5 color=Purple><i>The University of Queensland</i></h1>
    +"<h4><a href=http://imb.uq.edu.au/Microscopy/>ACRF: Cancer Biology Imaging Facility</a><h4>
    +"<h1><font color=black>ImageJ Script Macro: "+scripttitle+"</h1> 
    +"<p1>Version: "+version+" ("+date+")</p1>"
    +"<H2><font size=3>Created by Nicholas Condon</H2>"
    +"<p1><font size=2> contact n.condon@uq.edu.au \n </p1>" 
    +"<P4><font size=2> Available for use/modification/sharing under the "+"<p4><a href=https://opensource.org/licenses/MIT/>MIT License</a><h4> </P4>"
    +"<h3>   <h3>"    
    +"<p1><font size=3  i>"+description+"</p1>
    +"<h1><font size=2> </h1>"  
	   +"<h0><font size=5> </h0>"
    +"");
print("");
print("FIJI Macro: "+scripttitle);
print("Version: "+version+" Version Date: "+date);
print("ACRF: Cancer Biology Imaging Facility");
print("By Nicholas Condon (2021) n.condon@uq.edu.au")
print("");
getDateAndTime(year, month, week, day, hour, min, sec, msec);
print("Script Run Date: "+day+"/"+(month+1)+"/"+year+"  Time: " +hour+":"+min+":"+sec);
print("");

//Directory Warning and Instruction panel     
Dialog.create("Choosing your working directory.");
 	Dialog.addMessage("Use the next window to navigate to the directory of your images.");
  	Dialog.addMessage("(Note a sub-directory will be made within this folder for output files) ");
  	Dialog.addMessage("Take note of your file extension (eg .tif, .czi)");
Dialog.show(); 

//Directory Location
path = getDirectory("Choose Source Directory ");
list = getFileList(path);
getDateAndTime(year, month, week, day, hour, min, sec, msec);

ext = ".oir";
Dialog.create("Settings");
Dialog.addString("File Extension: ", ext);
Dialog.addMessage("(For example .czi  .lsm  .nd2  .lif  .ims)");
Dialog.show();
ext = Dialog.getString();

start = getTime();

//Creates Directory for output images/logs/results table
resultsDir = path+"_Results_"+"_"+year+"-"+month+"-"+day+"_at_"+hour+"."+min+"/"; 
File.makeDirectory(resultsDir);
print("Working Directory Location: "+path);
		selectWindow("Log");
		saveAs("Text", resultsDir+"Log.txt");
print("\\Clear");



summaryFile = File.open(resultsDir+"Results_detailed_"+"_"+year+"-"+month+"-"+day+"_at_"+hour+"."+min+".xls");
print(summaryFile,"Image Name \t Image Number \t Nuclei# \t Green Int \t Red Int");


print("Image Name,Image Number,Num Nuclei,Green Int,Normalised Green Int,Red Int,Normalised Red Int");
//File.close(summaryFile2);

for (z=0; z<list.length; z++) {
if (endsWith(list[z],ext)){

		run("Bio-Formats Importer", "open=["+path+list[z]+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		run("Clear Results");
		roiManager("reset");
		windowtitle = getTitle();
		windowtitlenoext = replace(windowtitle, ext, "");
			run("Duplicate...", "title=nuc duplicate channels=1");
			run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'nuc', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'0.0', 'percentileTop':'99.8', 'probThresh':'0.479071', 'nmsThresh':'0.2', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
			numNuc = roiManager("count");
			selectWindow(windowtitle);
			run("Duplicate...", "title=green duplicate channels=2");
			run("Clear Results");
			run("Measure");
			greentotInt=getResult("Mean",0);
			
			selectWindow(windowtitle);
			run("Duplicate...", "title=red duplicate channels=3");
			run("Clear Results");
			run("Measure");
			redtotInt=getResult("Mean",0);
			
			
			//run("Duplicate...", "duplicate channels=1");
			
			selectWindow("Label Image");
			
			greenIntArray = newArray(roiManager("count"));
			greenIntArrayBand = newArray(roiManager("count"));
			setBatchMode(true);
			for (i = 0; i < roiManager("count"); i++) {
			run("Clear Results");
			selectWindow("green");
			roiManager("select", i);
			run("Measure");
			greenIntArray[i] = getResult("Mean",0);
			}
			
			redIntArray = newArray(roiManager("count"));
			
			
			for (i = 0; i < roiManager("count"); i++) {
			run("Clear Results");
			selectWindow("red");
			roiManager("select", i);
			run("Measure");
			redIntArray[i] = getResult("Mean",0);
			}
			
			
			for (y = 0; y < roiManager("count"); y++) {
			print(summaryFile,windowtitle+"\t"+(z+1)+"\t"+(y+1)+"\t"+greenIntArray[y]+"\t"+redIntArray[y]);
			}
			setBatchMode(false);
			selectWindow("Label Image");
			saveAs("Tiff", resultsDir+windowtitle+"Label_Image.tif");
			roiManager("save", resultsDir+windowtitle+"_ROI.zip");
			
			while(nImages > 0){close();}
			

		
			print(windowtitle+","+(z+1)+","+numNuc+","+greentotInt+","+(greentotInt/numNuc)+","+redtotInt+","+(redtotInt/numNuc));
			
			

		}}
		selectWindow("Log");
		saveAs("Text", resultsDir+"Simple_Results.csv");
//exit message to notify user that the script has finished.
title = "Batch Completed";
msg = "Put down that coffee! Your analysis is finished";
waitForUser(title, msg);
