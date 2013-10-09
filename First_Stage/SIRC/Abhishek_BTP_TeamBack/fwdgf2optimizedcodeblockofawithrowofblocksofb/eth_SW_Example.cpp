//// Copyright: Microsoft 2009
////
//// Author: Ken Eguro and Sandro Forin
//// Includes code written by 2009 MSR intern Rene Mueller.
////
//// Created: 10/23/09 
////
//// Version: 1.1
//// 
//// Changelog:
//// Updated to fix bugs and compile from .lib
////
//// Description:
//// Example test program.
//// Test #1 - Read and write parameter registers
//// Test #2 - Soft reset of user logic
//// Test #3 - Test circuit:	send random input bytes to the FPGA 
////							multiply by 3
////							retrieve results
//// Test #4 - Test circuit: same as test #3, only use new random numbers & write/execute command
//// Test #5 - Test circuit: same as test #4, only show how to handle small output error of write/execute command
//// Test #6 - Write bandwidth test
//// Test #7 - Read bandwidth test
////----------------------------------------------------------------------------
////
//#include <windows.h>
//#include <WinIoctl.h>
//#include <setupapi.h>
//#include <iostream>
//#include <sstream>
//#include <fstream>
//#include <string>
//#include <iomanip>
//#include <assert.h>
//#include <list>
//#include <vector>
//#include <time.h>
//#include <direct.h>
//
//#include "sirc_internal.h"
//#include "display.h"
//
////#define BUGHUNT 1  In case its needed again in the future.
//
//using namespace std;
//using namespace System;
//using namespace System::IO;
//using namespace System::Collections;
//
//void error(string inErr){
//	cerr << "Error:" << endl;
//	cerr << "\t" << inErr << endl;
//
//    PrintZeLog();
//	exit(-1);
//}
//
//DWORD dwDisplayThreadID = 0;
//typedef char strbuf[64];
//strbuf lines[4];
//bool displayUpdated = false;
//
//DWORD WINAPI displayThreadProc(LPVOID lpParam){
//	SW_Example::display displayObj;
//	//eth_sirc_lib_SW_Example::display displayObj;
//	displayObj.Text = "SIRC Test Application";
//	displayObj.Show();
//	
//	MSG tempMsg;
//	while(1){
//		if(::GetMessage(&tempMsg, NULL, 0, 0) > 0){
//			if(tempMsg.message == WM_PAINT){
//                String ^t0, ^t1, ^t2, ^t3;
//                t0 = gcnew String(lines[0]);
//                t1 = gcnew String(lines[1]);
//                t2 = gcnew String(lines[2]);
//                t3 = gcnew String(lines[3]);
//				displayObj.updateStrings(t0, t1, t2, t3);
//				displayUpdated = true;
//			}
//            ::TranslateMessage(&tempMsg); 
//            ::DispatchMessage(&tempMsg);
//            if ((tempMsg.message == WM_DESTROY) ||
//                (tempMsg.message == WM_CLOSE) ||
//                (tempMsg.message == WM_QUIT))
//                break;
//		}
//		else{
//			break;
//		}
//	}
//    return 0;
//}
//
//int main(int argc, char* argv[]){
//	//Test harness variables
//	ETH_SIRC *SIRC_P;
//	uint8_t FPGA_ID[6];
//	bool FPGA_ID_DEF = false;
//	int a;
//	uint32_t numOps = 0;
//	uint32_t numOpsReturned;
//	uint32_t tempInt;
//	uint32_t artificialStopPoint;
//    uint32_t driverVersion = 0;
//
//	//How many bytes do we want to send for each bandwidth test?
//	//Default value = 8KB
//	int BANDWIDTHTESTSIZE = 0;
//	//How many times would we like to send this message?
//	int BANDWIDTHTESTITER = 0;
//
//	char *token = NULL;
//	char *next_token = NULL;
//	uint32_t val;
//	int waitTimeOut = 0;
//
//	//Input buffer
//	//uint8_t *inputValues;
//	uint32_t *inputValues;
//	//Output buffer
//	//uint8_t *outputValues;
//	uint32_t *outputValues;
//
//	//Speed testing variables
//	DWORD start, end;
//
//	std::ostringstream tempStream;
//
//	DWORD dwDisplayThreadID;
//
//#ifndef BUGHUNT
//    StartLog();
//#endif
//
//	//**** Process command line input
//	if (argc > 1) {
//		for(int i = 1; i < argc; i++){
//			if(strcmp(argv[i], "-mac") == 0){ 
//				if(argc <= i + 1){
//					tempStream << "-mac option requires argument";
//					error(tempStream.str());					
//				}
//				
//				//Map the target MAC address to an FPGA id.
//				val = hexToFpgaId(argv[i + 1],FPGA_ID, sizeof(FPGA_ID));
//				//Check to see if there were exactly 6 bytes
//				if (val!=6) {
//					tempStream << "Invalid MAC address. macToFpgaId returned " << i;
//					error(tempStream.str());
//				}
//
//				cout << "destination MAC: "
//						<< hex << setw(2) << setfill('0') 
//						<< setw(2) << (int)FPGA_ID[0] << ":" 
//						<< setw(2) << (int)FPGA_ID[1] << ":" 
//						<< setw(2) << (int)FPGA_ID[2] << ":" 
//						<< setw(2) << (int)FPGA_ID[3] << ":" 
//						<< setw(2) << (int)FPGA_ID[4] << ":" 
//						<< setw(2) << (int)FPGA_ID[5] << dec << endl;
//				FPGA_ID_DEF = true;
//				i++;
//			}
//			else if (strcmp(argv[i], "-numOps") == 0){
//				if(argc <= i + 1){
//					tempStream << "-numOps option requires argument";
//					error(tempStream.str());					
//				}
//				//Grab # of datapoints
//				numOps = (uint32_t) atoi(argv[i + 1]);
//				if ((numOps < 2)) {
//					tempStream << "Invalid number of operations: " << (int)numOps << ".  Must be > 1";
//					error(tempStream.str());
//				}
//				i++;
//			}
//			else if (strcmp(argv[i], "-waitTimeOut") == 0){
//				if(argc <= i + 1){
//					tempStream << "-waitTime option requires argument";
//					error(tempStream.str());					
//				}
//				waitTimeOut = (uint32_t) atoi(argv[i + 1]);
//				if ((waitTimeOut < 1)) {
//					tempStream << "Invalid waitTime: " << waitTimeOut << ".  Must be >= 1";
//					error(tempStream.str());
//				}
//				i++;
//			}
//			else if (strcmp(argv[i], "-bandwidthIter") == 0){
//				if(argc <= i + 1){
//					tempStream << "-bandwidthIter option requires argument";
//					error(tempStream.str());					
//				}
//				BANDWIDTHTESTITER = (uint32_t) atoi(argv[i + 1]);
//				if ((BANDWIDTHTESTITER < 1)) {
//					tempStream << "Invalid BANDWIDTHTESTITER: " << BANDWIDTHTESTITER << ".  Must be >= 1";
//					error(tempStream.str());
//				}
//				i++;
//			}
//			else{
//				tempStream << "Unknown option: " << argv[i] << endl;
//				tempStream << "Usage: " << argv[0] << " {-mac X:X:X:X:X:X} {-numOps X} {-waitTimeOut X} {-bandwidthIter X}" << endl;
//				error(tempStream.str());
//			}
//		}
//	} 
//	if(!FPGA_ID_DEF){
//		cout << "****USING DEFAULT MAC ADDRESS - AA:AA:AA:AA:AA:AA" << endl;
//		FPGA_ID[0] = 0xAA;
//		FPGA_ID[1] = 0xAA;
//		FPGA_ID[2] = 0xAA;
//		FPGA_ID[3] = 0xAA;
//		FPGA_ID[4] = 0xAA;
//		FPGA_ID[5] = 0xAA;
//	}
//
//	//**** Set up communication with FPGA
//	//Create communication object
//	SIRC_P = new ETH_SIRC(FPGA_ID, driverVersion, NULL);
//	//Make sure that the constructor didn't run into trouble
//    if (SIRC_P == NULL){
//		tempStream << "Unable to find a suitable SIRC driver or unable to ";
//		error(tempStream.str());
//    }
//	if(SIRC_P->getLastError() != 0){
//		tempStream << "Constructor failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	
//    //Get runtime parameters, for what we wont change.
//    SIRC::PARAMETERS params;
//    if (!SIRC_P->getParameters(&params,sizeof(params))){
//		tempStream << "Cannot getParameters from SIRC interface, code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//    }
//
//    //These MUST match the buffer sizes in the hw design.
//    params.maxInputDataBytes  = 1<<9; //2**17 128KBytes
//    params.maxOutputDataBytes = 1<<9; //2**13 8KBytes
//
//	if(waitTimeOut != 0){
//		params.writeTimeout = waitTimeOut;
//		params.readTimeout = waitTimeOut;
//	}
//
//	if (!SIRC_P->setParameters(&params,sizeof(params))){
//		tempStream << "Cannot setParameters on SIRC interface, code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//    }
//	
//    //Fill up the input buffer
//    if (numOps == 0){
//      // numOps = min(params.maxInputDataBytes, params.maxOutputDataBytes);
//		numOps = 64; // we want to send 8192 words
//	}
//	else if(numOps > params.maxInputDataBytes || numOps > params.maxOutputDataBytes){
//		tempStream << "Invalid number of operations defined, must be less than or equal to " 
//			<< (int)  min(params.maxInputDataBytes, params.maxOutputDataBytes);
//		error(tempStream.str());
//	}
//
//	if (BANDWIDTHTESTITER == 0){
//       BANDWIDTHTESTITER = 2000;
//	}
//	BANDWIDTHTESTSIZE = min(params.maxInputDataBytes, params.maxOutputDataBytes);
//
//	//Test parameter register reads and writes
//	cout << "****Beginning test #1 - parameter register testing" << endl;
//    LogIt(LOGIT_TIME_MARKER);
//	start = GetTickCount();
//	for(int i = 0; i < 255; i++){
//		if(!SIRC_P->sendParamRegisterWrite(i, i*i)){
//			tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//			error(tempStream.str());
//		}
//	}
//	
//	for(int i = 0; i < 255; i++){
//		if(!SIRC_P->sendParamRegisterRead(i, &tempInt)){
//			tempStream << "Parameter register read failed with code " << (int) SIRC_P->getLastError();
//			error(tempStream.str());
//		}
//		if(tempInt != i*i){
//			error("Parameter register read did not match expected value");
//		}
//	}
//	
//	end = GetTickCount();
//	cout << "Passed test #1" << endl;
//	cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
//
//	
//	cout << "****Beginning test #2 - soft reset testing" << endl;
//    LogIt(LOGIT_TIME_MARKER);
//	if(!SIRC_P->sendReset()){
//		tempStream << "Reset failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	cout << "Passed test #2" << endl << endl;
//
//	//This example circuit takes a few parameters:
//	//	Param Register 0 - number of input bytes
//	//	Param Register 1 - 32-bit multipler
//	//	Input buffer - N bytes to be multipled
//	//	Expected output - N bytes equal to (input values * multipler) % 256
//	cout << "****Beginning test #3 - simple test application" << endl;
//	
//	//inputValues = (uint8_t *) malloc(sizeof(uint8_t) * numOps);
//	inputValues = (uint32_t *) malloc(sizeof(uint32_t) * numOps);
//	assert(inputValues);
//	//outputValues = (uint8_t *) malloc(sizeof(uint8_t) * numOps);
//	outputValues = (uint32_t *) malloc(sizeof(uint32_t) * numOps);
//	assert(outputValues);
//
//	//Set input values to random bytes
//	for(int i = 0; i < 32; i++){
//		//inputValues[i] = rand() % 4294967296;
//		//inputValues[i] = 0xDEADBEEF;
//		//inputValues[i] = (0x80000000>>(i));
//		inputValues[i] = 0xFFFFFFFF;
//		cout<<inputValues[i]<< "  input1\n";
//	}
//	for(int i = 32; i < 64; i++){
//		//inputValues[i] = rand() % 4294967296;
//		inputValues[i] = (0x80000000>>(i-32));
//		//inputValues[i] = 0xDEADBEEF;
//		cout<<inputValues[i]<< "  input2\n";
//	}
//    LogIt(LOGIT_TIME_MARKER);
//	start = GetTickCount();
//	//Set parameter register 0 to the number of operations
//	if(!SIRC_P->sendParamRegisterWrite(0, numOps)){
//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	//Set parameter register 1 to a multiplier of 3
//	if(!SIRC_P->sendParamRegisterWrite(1, 3)){
//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	
//
//	
//	 
//	//Next, send the input data
//	//Start writing at address 0
//	if(!SIRC_P->sendWrite(0, 4*numOps, (uint8_t *)inputValues)){ // 4*numops because numops represents number of words and we are sending 4 byte words... so number of bytes to send = 4*numops
//		tempStream << "Write to FPGA failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	 __int64 ctr1 = 0, ctr2 = 0, freq = 0;
//	 QueryPerformanceCounter((LARGE_INTEGER *) &ctr1);
//	//Set the run signal
//	if(!SIRC_P->sendRun()){
//		tempStream << "Run command failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	
//	//Wait up to N seconds for the execution to finish (we can compute ~500M numbers in that time)
//	if(waitTimeOut == 0){
//		if(!SIRC_P->waitDone(400)){
//			cout<<"I am here\n";
//			tempStream << "Wait till done failed with code " << (int) SIRC_P->getLastError();
//			error(tempStream.str());
//		}
//	}
//	
//	else{
//		if(!SIRC_P->waitDone(waitTimeOut)){
//			tempStream << "Wait till done failed with code " << (int) SIRC_P->getLastError();
//			error(tempStream.str());
//		}
//	}
//	//Sleep(1000);
//	QueryPerformanceCounter((LARGE_INTEGER *) &ctr2);
//    QueryPerformanceFrequency((LARGE_INTEGER *) &freq);
//	
//	//Read the data back
//	if(!SIRC_P->sendRead(0, 2*numOps, (uint8_t *)outputValues)){                     //***********************
//		tempStream << "Read from FPGA failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	
//	
//	end = GetTickCount();
//	//Verify that the values are correct
//	for(int i = 0; i <32; i++){                                                    //***********************
//		//if((inputValues[i] * 3) % 256 != outputValues[i]){
//			//if(inputValues[i] != outputValues[i]){
//			//tempStream << "Output #" << (int) i << " does not match expected value";
//			//cin>>a;
//			//error(tempStream.str());
//		cout<<outputValues[i]<<"  output\n";
//		//}
//	}
//	
//	cout << "Passed test #3" << endl;
//	cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
//	cout << "Time Taken: "<< ((ctr2 - ctr1) * 1.0 / freq) << std::endl;
//	
//	//for (int i=0; i<100; i++)
//		//cout<< inputValues[4*i]<<"  .. " <<outputValues[i]<<"\n";
//
//	//cin>>a;
////	//**** Repeat the process with the write & execute command
////	cout << "****Beginning test #4 - Write & execute" << endl;
////	//Set input values to new random bytes
////	for(int i = 0; i < numOps; i++){
////		inputValues[i] = rand() % 256;
////	}
////	
////#ifdef BUGHUNT
////    StartLog();
////#endif
////    LogIt(LOGIT_TIME_MARKER);
////    LogIt("test #4 - Write & execute");
////	start = GetTickCount();
////	//Set parameter register 0 to the number of operations
////	//Technically, this isn't necessary since the parameter register values shouldn't have changed
////	if(!SIRC_P->sendParamRegisterWrite(0, numOps)){
////		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
////		error(tempStream.str());
////	}
////	//Set parameter register 1 to a multiplier of 3
////	//Technically, this isn't necessary since the parameter register values shouldn't have changed
////	if(!SIRC_P->sendParamRegisterWrite(1, 3)){
////		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
////		error(tempStream.str());
////	}
////
////	//Wait up to N seconds for the execution to finish (we can compute ~500M numbers in that time)
////	if(waitTimeOut == 0){
////		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, 4000, outputValues, numOps, &numOpsReturned)){
////			//Check to see what the problem was
////			tempStream << "Write & Run command failed with code " << (int) SIRC_P->getLastError();
////			error(tempStream.str());
////		}
////	}
////	else{
////		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, waitTimeOut, outputValues, numOps, &numOpsReturned)){
////			//Check to see what the problem was
////			tempStream << "Write & Run command failed with code " << (int) SIRC_P->getLastError();
////			error(tempStream.str());
////		}
////	}	
////
////	end = GetTickCount();
////#ifdef BUGHUNT
////    LogIt(LOGIT_TIME_MARKER);
////    UINT32 susp = StopLog();
////#endif
////
////	//Verify that the values are correct
////	for(int i = 0; i < numOps; i++){
////		//if((inputValues[i] * 3) % 256 != outputValues[i]){
////		if(inputValues[i] != outputValues[i]){
////			tempStream << "Output #" << (int) i << " does not match expected value";
////			error(tempStream.str());
////		}
////	}
////	cout << "Passed test #4" << endl;
////	cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
////	
////	//**** Repeat the process with the write & execute command, but purposely make the readback buffer
////	// seem too small.  This will force us to manually read back the output buffer.
////	cout << "****Beginning test #5 - Write & execute w/capacity error" << endl;
////	//Set input values to new random bytes
////	for(int i = 0; i < numOps; i++){
////		inputValues[i] = rand() % 256;
////	}
////	artificialStopPoint = numOps - 1;
////
////    LogIt(LOGIT_TIME_MARKER);
////	start = GetTickCount();
////	//Set parameter register 0 to the number of operations
////	//Technically, this isn't necessary since the parameter register values shouldn't have changed
////	if(!SIRC_P->sendParamRegisterWrite(0, numOps)){
////		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
////		error(tempStream.str());
////	}
////	//Set parameter register 1 to a multiplier of 3
////	//Technically, this isn't necessary since the parameter register values shouldn't have changed
////	if(!SIRC_P->sendParamRegisterWrite(1, 3)){
////		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
////		error(tempStream.str());
////	}
////	
////	if(waitTimeOut == 0){	
////		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, 4000, outputValues, artificialStopPoint, &numOpsReturned)){
////			//Check to see what the problem was
////			cout << "\tWrite&run function failed with code " << (int) SIRC_P->getLastError() << endl;
////			if(SIRC_P->getLastError() != FAILWRITEANDRUNCAPACITY){
////				error("This is an unexpected failure");
////			}
////		}
////	}
////	else{
////		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, waitTimeOut, outputValues, artificialStopPoint, &numOpsReturned)){
////			//Check to see what the problem was
////			cout << "\tWrite&run function failed with code " << (int) SIRC_P->getLastError() << endl;
////			if(SIRC_P->getLastError() != FAILWRITEANDRUNCAPACITY){
////				error("This is an unexpected failure");
////			}
////		}
////
////	}
////	cout << "\tError is expected, continuing" << endl;
////	//Manually read the data at addresses {artificialStopPoint, outputLength-1} back
////	if(!SIRC_P->sendRead(artificialStopPoint, numOpsReturned - artificialStopPoint, outputValues + artificialStopPoint)){
////		tempStream << "Read from FPGA failed with code " << (int) SIRC_P->getLastError();
////		error(tempStream.str());
////	}
////	end = GetTickCount();
////
////	//Verify that the values are correct
////	for(int i = 0; i < numOps; i++){
////		//if((inputValues[i] * 3) % 256 != outputValues[i]){
////		if(inputValues[i] != outputValues[i]){
////			tempStream << "Output #" << (int) i << " does not match expected value";
////			error(tempStream.str());
////		}
////	}
////
////	cout << "Passed test #5" << endl;
////	cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
////
////	
////	//**** Try to send a M byte chunk of data N times
////	free(inputValues);
////	inputValues = (uint8_t *) malloc(sizeof(uint8_t) * BANDWIDTHTESTSIZE);
////
////	//Create the display thread
////	HANDLE hDisplayThread = CreateThread(NULL, 0, &displayThreadProc, (LPVOID) 0, 0, &dwDisplayThreadID);
////	if(!hDisplayThread){
////		tempStream << "Could not create diplay thread!";
////		error(tempStream.str());
////	}
////
////	//Repeat the bandwidth tests a bunch of times.
////    double bw, bestRead = 0.0, bestWrite = 0.0;
////	
////	cout << "****Beginning tests #6 & #7 - write and read bandwidth" << endl;
////	for (int n = 0; n < 5; n++){
////        cout << "****Testing write bandwidth" << endl;
////        LogIt("main::****Testing write bandwidth");
////        LogIt(LOGIT_TIME_MARKER);
////        start = GetTickCount();
////        for(int i = 0; i < BANDWIDTHTESTITER; i++){
////            if(!SIRC_P->sendWrite(0, BANDWIDTHTESTSIZE, inputValues)){
////                tempStream << "Write to FPGA failed with code " << (int) SIRC_P->getLastError();
////                error(tempStream.str());
////            }
////        }
////        end = GetTickCount();
////
////        bw = ((double)8 * (double) BANDWIDTHTESTSIZE * (double)BANDWIDTHTESTITER) / 
////            (((double)(end - start)) * 1000);
////        if (bestWrite < bw)
////            bestWrite = bw;
////
////        cout << "\tWrite time = " << (end - start) << " ms" << endl;
////        cout << "\tWrite bandwidth = " << bw << " Mbps" << endl << endl;
////
////		_snprintf_s(lines[0],sizeof(strbuf), _TRUNCATE, "Write bandwidth test #%d", n);
////		_snprintf_s(lines[1],sizeof(strbuf), _TRUNCATE, "\t%g Mbps", bw);
////		PostThreadMessage(dwDisplayThreadID, WM_PAINT, NULL, NULL);
////
////		while(!displayUpdated){
////			//busy wait until the display has been updated
////		}
////		displayUpdated = false;
////
////        //**** Try to read a M byte chunk of data N times
////        free(outputValues);
////        outputValues = (uint8_t *) malloc(sizeof(uint8_t) * BANDWIDTHTESTSIZE);
////
////        cout << "****Testing read bandwidth" << endl;
////        LogIt("main::****Testing read bandwidth");
////        LogIt(LOGIT_TIME_MARKER);
////        start = GetTickCount();
////        for(int i = 0; i < BANDWIDTHTESTITER; i++){
////            if(!SIRC_P->sendRead(0, BANDWIDTHTESTSIZE, outputValues)){
////                tempStream << "Read from FPGA failed with code " << (int) SIRC_P->getLastError();
////                error(tempStream.str());
////            }
////        }
////        end = GetTickCount();
////
////        bw = ((double)8 * (double) BANDWIDTHTESTSIZE * (double)BANDWIDTHTESTITER) / 
////            (((double)(end - start)) * 1000);
////        if (bestRead < bw)
////            bestRead = bw;
////        cout << "\tRead time = " << (end - start) << " ms" << endl;
////        cout << "\tRead bandwidth = " << bw << " Mbps" << endl << endl;
////
////		_snprintf_s(lines[2],sizeof(strbuf), _TRUNCATE, "Read bandwidth test #%d", n);
////		_snprintf_s(lines[3],sizeof(strbuf), _TRUNCATE, "\t%g Mbps", bw);
////		PostThreadMessage(dwDisplayThreadID, WM_PAINT, NULL, NULL);
////
////		while(!displayUpdated){
////			//busy wait until the display has been updated
////		}
////		displayUpdated = false;
////	}
////
////	cout << "\tBest write bandwidth = " << bestWrite << " Mbps" << endl;
////	cout << "\tBest read bandwidth = " << bestRead << " Mbps" << endl << endl;
//	cin>>a;
//	delete SIRC_P;
//	free(inputValues);
//	free(outputValues);
//
//#ifdef BUGHUNT
//    StartLog(susp);
//#endif
//    PrintZeLog();
//	return 0;
//}


//////////////////////////////////////////////large matrix code////////////////////////////////////////////////////////////
// Copyright: Microsoft 2009
//
// Author: Ken Eguro and Sandro Forin
// Includes code written by 2009 MSR intern Rene Mueller.
//
// Created: 10/23/09 
//
// Version: 1.1
// 
// Changelog:
// Updated to fix bugs and compile from .lib
//
// Description:
// Example test program.
// Test #1 - Read and write parameter registers
// Test #2 - Soft reset of user logic
// Test #3 - Test circuit:	send random input bytes to the FPGA 
//							multiply by 3
//							retrieve results
// Test #4 - Test circuit: same as test #3, only use new random numbers & write/execute command
// Test #5 - Test circuit: same as test #4, only show how to handle small output error of write/execute command
// Test #6 - Write bandwidth test
// Test #7 - Read bandwidth test
//----------------------------------------------------------------------------
//
#include <windows.h>
#include <WinIoctl.h>
#include <setupapi.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <iomanip>
#include <assert.h>
#include <list>
#include <vector>
#include <time.h>
#include <direct.h>
#include <tchar.h>
#include <stdio.h>
#include <strsafe.h>
#include "sirc_internal.h"
#include "display.h"

#define N 1024		// this is the size of input matrices

//#define BUGHUNT 1  In case its needed again in the future.

using namespace std;
using namespace System;
using namespace System::IO;
using namespace System::Collections;

void error(string inErr){
	cerr << "Error:" << endl;
	cerr << "\t" << inErr << endl;
	int a;
	cin>>a;
    PrintZeLog();
	exit(-1);
}

DWORD dwDisplayThreadID = 0;
typedef char strbuf[64];
strbuf lines[4];
bool displayUpdated = false;

DWORD WINAPI displayThreadProc(LPVOID lpParam){
	SW_Example::display displayObj;
	//eth_sirc_lib_SW_Example::display displayObj;
	displayObj.Text = "SIRC Test Application";
	displayObj.Show();
	
	MSG tempMsg;
	while(1){
		if(::GetMessage(&tempMsg, NULL, 0, 0) > 0){
			if(tempMsg.message == WM_PAINT){
                String ^t0, ^t1, ^t2, ^t3;
                t0 = gcnew String(lines[0]);
                t1 = gcnew String(lines[1]);
                t2 = gcnew String(lines[2]);
                t3 = gcnew String(lines[3]);
				displayObj.updateStrings(t0, t1, t2, t3);
				displayUpdated = true;
			}
            ::TranslateMessage(&tempMsg); 
            ::DispatchMessage(&tempMsg);
            if ((tempMsg.message == WM_DESTROY) ||
                (tempMsg.message == WM_CLOSE) ||
                (tempMsg.message == WM_QUIT))
                break;
		}
		else{
			break;
		}
	}
    return 0;
}

int main(int argc, char* argv[]){
	//Test harness variables
	ETH_SIRC *SIRC_P;
	uint8_t FPGA_ID[6];
	bool FPGA_ID_DEF = false;
	int a;
	uint32_t numOps = 0;
	uint32_t numOpsReturned;
	uint32_t tempInt;
	uint32_t artificialStopPoint;
   	uint32_t driverVersion = 0;
	//int sizewrite=(N/32)*(N/32)*(N/32);
	int sizewrite=(N/32)*(N/32);
	double *writeTime=new double[sizewrite];


	//How many bytes do we want to send for each bandwidth test?
	//Default value = 8KB
	int BANDWIDTHTESTSIZE = 0;
	//How many times would we like to send this message?
	int BANDWIDTHTESTITER = 0;

	char *token = NULL;
	char *next_token = NULL;
	uint32_t val;
	int waitTimeOut = 0;

	//Input buffer
	//uint8_t *inputValues;
	uint32_t *inputValues;
	//Output buffer
	//uint8_t *outputValues;
	uint32_t *outputValues;

	//Speed testing variables
	DWORD start, end;

	std::ostringstream tempStream;

	DWORD dwDisplayThreadID;

	uint32_t** matA = new uint32_t*[N];
	uint32_t** matB = new uint32_t*[N];
	uint32_t** matC = new uint32_t*[N];
	//uint32_t* countervalues = new uint32_t[(N/32)*(N/32)*(N/32)];
	uint32_t* countervalues = new uint32_t[(N/32)*(N/32)];
	int s = 0;
	for(int i = 0; i < N; ++i){
	    matA[i] = new uint32_t[N/32];
	    matB[i] = new uint32_t[N/32];
	    matC[i] = new uint32_t[N/32];
	}

	// cout << "Matrix A is \n\n" ; 
	   for(int i=0;i<N;i++){
	    for(int j=0;j<N/32;j++){
	     matA[i][j] = 0x00000008; 
	     matC[i][j] = 0x00000000;			// initialize matrix C also    
	   // cout << matA[i][j];
	    }
	   // cout << endl;
	   }

	cout << "Matrix B is \n\n" ; 
	   for(int i=0;i<N;i++){
	    for(int j=0;j<N/32;j++){
	     if(j==(i/32)) matB[i][j] = 0x80000000 >> (i%32);   
	     else matB[i][j] = 0x00000000 ;  
	  cout <<matB[i][j]<<hex ;
	    }
	    cout << endl;
	   }

#ifndef BUGHUNT
    StartLog();
#endif

	//**** Process command line input
	if (argc > 1) {
		for(int i = 1; i < argc; i++){
			if(strcmp(argv[i], "-mac") == 0){ 
				if(argc <= i + 1){
					tempStream << "-mac option requires argument";
					error(tempStream.str());					
				}
				
				//Map the target MAC address to an FPGA id.
				val = hexToFpgaId(argv[i + 1],FPGA_ID, sizeof(FPGA_ID));
				//Check to see if there were exactly 6 bytes
				if (val!=6) {
					tempStream << "Invalid MAC address. macToFpgaId returned " << i;
					error(tempStream.str());
				}

				cout << "destination MAC: "
						<< hex << setw(2) << setfill('0') 
						<< setw(2) << (int)FPGA_ID[0] << ":" 
						<< setw(2) << (int)FPGA_ID[1] << ":" 
						<< setw(2) << (int)FPGA_ID[2] << ":" 
						<< setw(2) << (int)FPGA_ID[3] << ":" 
						<< setw(2) << (int)FPGA_ID[4] << ":" 
						<< setw(2) << (int)FPGA_ID[5] << dec << endl;
				FPGA_ID_DEF = true;
				i++;
			}
			else if (strcmp(argv[i], "-numOps") == 0){
				if(argc <= i + 1){
					tempStream << "-numOps option requires argument";
					error(tempStream.str());					
				}
				//Grab # of datapoints
				numOps = (uint32_t) atoi(argv[i + 1]);
				if ((numOps < 2)) {
					tempStream << "Invalid number of operations: " << (int)numOps << ".  Must be > 1";
					error(tempStream.str());
				}
				i++;
			}
			else if (strcmp(argv[i], "-waitTimeOut") == 0){
				if(argc <= i + 1){
					tempStream << "-waitTime option requires argument";
					error(tempStream.str());					
				}
				waitTimeOut = (uint32_t) atoi(argv[i + 1]);
				if ((waitTimeOut < 1)) {
					tempStream << "Invalid waitTime: " << waitTimeOut << ".  Must be >= 1";
					error(tempStream.str());
				}
				i++;
			}
			else if (strcmp(argv[i], "-bandwidthIter") == 0){
				if(argc <= i + 1){
					tempStream << "-bandwidthIter option requires argument";
					error(tempStream.str());					
				}
				BANDWIDTHTESTITER = (uint32_t) atoi(argv[i + 1]);
				if ((BANDWIDTHTESTITER < 1)) {
					tempStream << "Invalid BANDWIDTHTESTITER: " << BANDWIDTHTESTITER << ".  Must be >= 1";
					error(tempStream.str());
				}
				i++;
			}
			else{
				tempStream << "Unknown option: " << argv[i] << endl;
				tempStream << "Usage: " << argv[0] << " {-mac X:X:X:X:X:X} {-numOps X} {-waitTimeOut X} {-bandwidthIter X}" << endl;
				error(tempStream.str());
			}
		}
	} 
	if(!FPGA_ID_DEF){
		cout << "****USING DEFAULT MAC ADDRESS - AA:AA:AA:AA:AA:AA" << endl;
		FPGA_ID[0] = 0xAA;
		FPGA_ID[1] = 0xAA;
		FPGA_ID[2] = 0xAA;
		FPGA_ID[3] = 0xAA;
		FPGA_ID[4] = 0xAA;
		FPGA_ID[5] = 0xAA;
	}

	//**** Set up communication with FPGA
	//Create communication object
	SIRC_P = new ETH_SIRC(FPGA_ID, driverVersion, NULL);
	//Make sure that the constructor didn't run into trouble
    if (SIRC_P == NULL){
		tempStream << "Unable to find a suitable SIRC driver or unable to ";
		error(tempStream.str());
    }
	if(SIRC_P->getLastError() != 0){
		tempStream << "Constructor failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}
	
    //Get runtime parameters, for what we wont change.
    SIRC::PARAMETERS params;
    if (!SIRC_P->getParameters(&params,sizeof(params))){
		tempStream << "Cannot getParameters from SIRC interface, code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
    }

    //These MUST match the buffer sizes in the hw design.
    params.maxInputDataBytes  = 1<<13; //2**17 128KBytes
    params.maxOutputDataBytes = 1<<13; //2**13 8KBytes

	if(waitTimeOut != 0){
		params.writeTimeout = waitTimeOut;
		params.readTimeout = waitTimeOut;
	}

	if (!SIRC_P->setParameters(&params,sizeof(params))){
		tempStream << "Cannot setParameters on SIRC interface, code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
    }
	
    //Fill up the input buffer
    if (numOps == 0){
      // numOps = min(params.maxInputDataBytes, params.maxOutputDataBytes);
		numOps = 33*32; // we want to send 8192 words
	}
	//else if(numOps > params.maxInputDataBytes || numOps > params.maxOutputDataBytes){
	//	tempStream << "Invalid number of operations defined, must be less than or equal to " 
	//		<< (int)  min(params.maxInputDataBytes, params.maxOutputDataBytes);
	//	error(tempStream.str());
	//}

	//if (BANDWIDTHTESTITER == 0){
 //      BANDWIDTHTESTITER = 2000;
	//}
	//BANDWIDTHTESTSIZE = min(params.maxInputDataBytes, params.maxOutputDataBytes);

	////Test parameter register reads and writes
	//cout << "****Beginning test #1 - parameter register testing" << endl;
 //   LogIt(LOGIT_TIME_MARKER);
	//start = GetTickCount();
	//for(int i = 0; i < 255; i++){
	//	if(!SIRC_P->sendParamRegisterWrite(i, i*i)){
	//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
	//		error(tempStream.str());
	//	}
	//}
	//
	//for(int i = 0; i < 255; i++){
	//	if(!SIRC_P->sendParamRegisterRead(i, &tempInt)){
	//		tempStream << "Parameter register read failed with code " << (int) SIRC_P->getLastError();
	//		error(tempStream.str());
	//	}
	//	if(tempInt != i*i){
	//		error("Parameter register read did not match expected value");
	//	}
	//}
	//
	//end = GetTickCount();
	//cout << "Passed test #1" << endl;
	//cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;

	//
	//cout << "****Beginning test #2 - soft reset testing" << endl;
 //   LogIt(LOGIT_TIME_MARKER);
	//if(!SIRC_P->sendReset()){
	//	tempStream << "Reset failed with code " << (int) SIRC_P->getLastError();
	//	error(tempStream.str());
	//}
	//cout << "Passed test #2" << endl << endl;

	//This example circuit takes a few parameters:
	//	Param Register 0 - number of input bytes
	//	Param Register 1 - 32-bit multipler
	//	Input buffer - N bytes to be multipled
	//	Expected output - N bytes equal to (input values * multipler) % 256
	cout << "****Beginning test #3 - simple test application" << endl;
	
	//inputValues = (uint8_t *) malloc(sizeof(uint8_t) * numOps);
	inputValues = (uint32_t *) malloc(sizeof(uint32_t) * numOps);
	assert(inputValues);
	//outputValues = (uint8_t *) malloc(sizeof(uint8_t) * numOps);
	outputValues = (uint32_t *) malloc(sizeof(uint32_t) * numOps);
	assert(outputValues);

/*
	//Set input values to random bytes
	for(int i = 0; i < 32; i++){
		//inputValues[i] = rand() % 4294967296;
		//inputValues[i] = 0xDEADBEEF;
		//inputValues[i] = (0x80000000>>(i));
		inputValues[i] = 0xFFFFFFFF;
		cout<<inputValues[i]<< "  input1\n";
	}
	for(int i = 32; i < 64; i++){
		//inputValues[i] = rand() % 4294967296;
		inputValues[i] = (0x80000000>>(i-32));
		//inputValues[i] = 0xDEADBEEF;
		cout<<inputValues[i]<< "  input2\n";
	}
*/


    LogIt(LOGIT_TIME_MARKER);
	//start = GetTickCount();

	 __int64 ctr1 = 0, ctr2 = 0, freq = 0;
	 
	//Set parameter register 0 to the number of operations
	if(!SIRC_P->sendParamRegisterWrite(0, numOps)){
		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}
	//Set parameter register 1 to a multiplier of 3
	if(!SIRC_P->sendParamRegisterWrite(1, 3)){
		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}

//QueryPerformanceCounter((LARGE_INTEGER *) &ctr1);
double realfpgatime = 0.0;

// input matrices are A & B, one is DEADBEEF (N*N/32 occurrences) and another is I matrix
// Now load input matrices into inputValues
	
for(int i=0;i<N/32;i++)
{
 for(int j=0;j<N/32;j++)
 {


  // Load block from matrix A
  for(int m=0;m<32;m++)
  { 
    inputValues[m] = matA[i*32+m][j]; 
  }

  // Load block from matrix B
  for(int q=0;q<N/32;q++){

  for(int m=0;m<32;m++)
  {
    inputValues[m+32+32*q] = matB[j*32+m][q];
  }


  }
 /*
  // Load block from matrix B
  for(int m=0;m<32*6;m++)
  {
    inputValues[m+64] = matB[p*32+(m%32)][j];
  }
 */
 QueryPerformanceCounter((LARGE_INTEGER *) &ctr1);
  //sendWrite, sendRun, sendRead
  if(!SIRC_P->sendReset()){
		tempStream << "Reset failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}
  
	uint32_t outputLength=(uint32_t) 32*32;
	
	//Next, send the input data
	//Start writing at address 0
	 
	if(!SIRC_P->sendWriteAndRun(0,4*numOps,(uint8_t *)inputValues,30000,(uint8_t *)outputValues,4*(numOps-32)+4,& outputLength)){ //+4 is for counter
		// 4*numops because numops represents number of words and we are sending 4 byte words... so number of bytes to send = 4*numops
		cout<<"Here";
		cin>>a;
		tempStream << "Write to FPGA failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}
	QueryPerformanceCounter((LARGE_INTEGER *) &ctr2);
	QueryPerformanceFrequency((LARGE_INTEGER *) &freq);
	realfpgatime += ((ctr2 - ctr1) * 1.0 / freq);
	
	/*
	if(!SIRC_P->sendWrite(0,4*numOps,(uint8_t *)inputValues)){ 
		// 4*numops because numops represents number of words and we are sending 4 byte words... so number of bytes to send = 4*numops
		
		tempStream << "Write to FPGA failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}
	
		
	//Set the run signal
	if(!SIRC_P->sendRun()){
		tempStream << "Run command failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}

	
	
	//Wait up to N seconds for the execution to finish (we can compute ~500M numbers in that time)
	if(waitTimeOut == 0){
		if(!SIRC_P->waitDone(4000)){
			cout<<"I am here\n";
			tempStream << "Wait till done failed with code " << (int) SIRC_P->getLastError();
			error(tempStream.str());
		}

	
	else{
		if(!SIRC_P->waitDone(waitTimeOut)){
			tempStream << "Wait till done failed with code " << (int) SIRC_P->getLastError();
			error(tempStream.str());
		}
	}	
	
	
	
	//Read the data back
	if(!SIRC_P->sendRead(0, 2*numOps, (uint8_t *)outputValues)){                     //***********************
		tempStream << "Read from FPGA failed with code " << (int) SIRC_P->getLastError();
		error(tempStream.str());
	}
	*/
	
// Now accumulate into matrix C
for(int r=0; r<(N/32); r++)
{
  for(int m=0;m<32;m++)
  {
    matC[i*32+m][r] ^= outputValues[m+32*r] ;
  }
} 
  countervalues[s++] = outputValues[1024];
 
// end of computation of matrix block C[i][j]

 }
}


	//QueryPerformanceCounter((LARGE_INTEGER *) &ctr2);
	//QueryPerformanceFrequency((LARGE_INTEGER *) &freq);
	//writeTime[i*(N/32)*(N/32)+j*(N/32)+p]=((ctr2 - ctr1) * 1.0 / freq);
	

/*
	//Verify that the values are correct
	for(int i = 0; i <32; i++){                                                    //***********************
		//if((inputValues[i] * 3) % 256 != outputValues[i]){
			//if(inputValues[i] != outputValues[i]){
			//tempStream << "Output #" << (int) i << " does not match expected value";
			//cin>>a;
			//error(tempStream.str());
		cout<<outputValues[i]<<"  output\n";
		//}
	}
*/

	
// Print out the C Matrix
	cout << "Matrix C is \n\n" ; 
	   for(int i=0;i<N;i++){
	    for(int j=0;j<N/32;j++){
	     // initialize matrix C also    
	     cout << matC[i][j]<<"  " ;
	    }
	    cout << endl;
	   }
	
	
	cout << "Passed test #3" << endl;
	//cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
	
	for(int y=0;y< 10;y++)
		cout<<writeTime[y]<<endl;
	cout << "Time Taken: "<< ((ctr2 - ctr1) * 1.0 / freq) << std::endl;

	cout << "But fpga time is " << realfpgatime << endl;

	//for (int i=0; i<100; i++)
		//cout<< inputValues[4*i]<<"  .. " <<outputValues[i]<<"\n";

	//cin>>a;
//	//**** Repeat the process with the write & execute command
//	cout << "****Beginning test #4 - Write & execute" << endl;
//	//Set input values to new random bytes
//	for(int i = 0; i < numOps; i++){
//		inputValues[i] = rand() % 256;
//	}
//	
//#ifdef BUGHUNT
//    StartLog();
//#endif
//    LogIt(LOGIT_TIME_MARKER);
//    LogIt("test #4 - Write & execute");
//	start = GetTickCount();
//	//Set parameter register 0 to the number of operations
//	//Technically, this isn't necessary since the parameter register values shouldn't have changed
//	if(!SIRC_P->sendParamRegisterWrite(0, numOps)){
//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	//Set parameter register 1 to a multiplier of 3
//	//Technically, this isn't necessary since the parameter register values shouldn't have changed
//	if(!SIRC_P->sendParamRegisterWrite(1, 3)){
//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//
//	//Wait up to N seconds for the execution to finish (we can compute ~500M numbers in that time)
//	if(waitTimeOut == 0){
//		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, 4000, outputValues, numOps, &numOpsReturned)){
//			//Check to see what the problem was
//			tempStream << "Write & Run command failed with code " << (int) SIRC_P->getLastError();
//			error(tempStream.str());
//		}
//	}
//	else{
//		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, waitTimeOut, outputValues, numOps, &numOpsReturned)){
//			//Check to see what the problem was
//			tempStream << "Write & Run command failed with code " << (int) SIRC_P->getLastError();
//			error(tempStream.str());
//		}
//	}	
//
//	end = GetTickCount();
//#ifdef BUGHUNT
//    LogIt(LOGIT_TIME_MARKER);
//    UINT32 susp = StopLog();
//#endif
//
//	//Verify that the values are correct
//	for(int i = 0; i < numOps; i++){
//		//if((inputValues[i] * 3) % 256 != outputValues[i]){
//		if(inputValues[i] != outputValues[i]){
//			tempStream << "Output #" << (int) i << " does not match expected value";
//			error(tempStream.str());
//		}
//	}
//	cout << "Passed test #4" << endl;
//	cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
//	
//	//**** Repeat the process with the write & execute command, but purposely make the readback buffer
//	// seem too small.  This will force us to manually read back the output buffer.
//	cout << "****Beginning test #5 - Write & execute w/capacity error" << endl;
//	//Set input values to new random bytes
//	for(int i = 0; i < numOps; i++){
//		inputValues[i] = rand() % 256;
//	}
//	artificialStopPoint = numOps - 1;
//
//    LogIt(LOGIT_TIME_MARKER);
//	start = GetTickCount();
//	//Set parameter register 0 to the number of operations
//	//Technically, this isn't necessary since the parameter register values shouldn't have changed
//	if(!SIRC_P->sendParamRegisterWrite(0, numOps)){
//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	//Set parameter register 1 to a multiplier of 3
//	//Technically, this isn't necessary since the parameter register values shouldn't have changed
//	if(!SIRC_P->sendParamRegisterWrite(1, 3)){
//		tempStream << "Parameter register write failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	
//	if(waitTimeOut == 0){	
//		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, 4000, outputValues, artificialStopPoint, &numOpsReturned)){
//			//Check to see what the problem was
//			cout << "\tWrite&run function failed with code " << (int) SIRC_P->getLastError() << endl;
//			if(SIRC_P->getLastError() != FAILWRITEANDRUNCAPACITY){
//				error("This is an unexpected failure");
//			}
//		}
//	}
//	else{
//		if(!SIRC_P->sendWriteAndRun(0, numOps, inputValues, waitTimeOut, outputValues, artificialStopPoint, &numOpsReturned)){
//			//Check to see what the problem was
//			cout << "\tWrite&run function failed with code " << (int) SIRC_P->getLastError() << endl;
//			if(SIRC_P->getLastError() != FAILWRITEANDRUNCAPACITY){
//				error("This is an unexpected failure");
//			}
//		}
//
//	}
//	cout << "\tError is expected, continuing" << endl;
//	//Manually read the data at addresses {artificialStopPoint, outputLength-1} back
//	if(!SIRC_P->sendRead(artificialStopPoint, numOpsReturned - artificialStopPoint, outputValues + artificialStopPoint)){
//		tempStream << "Read from FPGA failed with code " << (int) SIRC_P->getLastError();
//		error(tempStream.str());
//	}
//	end = GetTickCount();
//
//	//Verify that the values are correct
//	for(int i = 0; i < numOps; i++){
//		//if((inputValues[i] * 3) % 256 != outputValues[i]){
//		if(inputValues[i] != outputValues[i]){
//			tempStream << "Output #" << (int) i << " does not match expected value";
//			error(tempStream.str());
//		}
//	}
//
//	cout << "Passed test #5" << endl;
//	cout << "\tExecuted in " << (end - start) << " ms" << endl << endl;
//
//	
//	//**** Try to send a M byte chunk of data N times
//	free(inputValues);
//	inputValues = (uint8_t *) malloc(sizeof(uint8_t) * BANDWIDTHTESTSIZE);
//
//	//Create the display thread
//	HANDLE hDisplayThread = CreateThread(NULL, 0, &displayThreadProc, (LPVOID) 0, 0, &dwDisplayThreadID);
//	if(!hDisplayThread){
//		tempStream << "Could not create diplay thread!";
//		error(tempStream.str());
//	}
//
//	//Repeat the bandwidth tests a bunch of times.
//    double bw, bestRead = 0.0, bestWrite = 0.0;
//	
//	cout << "****Beginning tests #6 & #7 - write and read bandwidth" << endl;
//	for (int n = 0; n < 5; n++){
//        cout << "****Testing write bandwidth" << endl;
//        LogIt("main::****Testing write bandwidth");
//        LogIt(LOGIT_TIME_MARKER);
//        start = GetTickCount();
//        for(int i = 0; i < BANDWIDTHTESTITER; i++){
//            if(!SIRC_P->sendWrite(0, BANDWIDTHTESTSIZE, inputValues)){
//                tempStream << "Write to FPGA failed with code " << (int) SIRC_P->getLastError();
//                error(tempStream.str());
//            }
//        }
//        end = GetTickCount();
//
//        bw = ((double)8 * (double) BANDWIDTHTESTSIZE * (double)BANDWIDTHTESTITER) / 
//            (((double)(end - start)) * 1000);
//        if (bestWrite < bw)
//            bestWrite = bw;
//
//        cout << "\tWrite time = " << (end - start) << " ms" << endl;
//        cout << "\tWrite bandwidth = " << bw << " Mbps" << endl << endl;
//
//		_snprintf_s(lines[0],sizeof(strbuf), _TRUNCATE, "Write bandwidth test #%d", n);
//		_snprintf_s(lines[1],sizeof(strbuf), _TRUNCATE, "\t%g Mbps", bw);
//		PostThreadMessage(dwDisplayThreadID, WM_PAINT, NULL, NULL);
//
//		while(!displayUpdated){
//			//busy wait until the display has been updated
//		}
//		displayUpdated = false;
//
//        //**** Try to read a M byte chunk of data N times
//        free(outputValues);
//        outputValues = (uint8_t *) malloc(sizeof(uint8_t) * BANDWIDTHTESTSIZE);
//
//        cout << "****Testing read bandwidth" << endl;
//        LogIt("main::****Testing read bandwidth");
//        LogIt(LOGIT_TIME_MARKER);
//        start = GetTickCount();
//        for(int i = 0; i < BANDWIDTHTESTITER; i++){
//            if(!SIRC_P->sendRead(0, BANDWIDTHTESTSIZE, outputValues)){
//                tempStream << "Read from FPGA failed with code " << (int) SIRC_P->getLastError();
//                error(tempStream.str());
//            }
//        }
//        end = GetTickCount();
//
//        bw = ((double)8 * (double) BANDWIDTHTESTSIZE * (double)BANDWIDTHTESTITER) / 
//            (((double)(end - start)) * 1000);
//        if (bestRead < bw)
//            bestRead = bw;
//        cout << "\tRead time = " << (end - start) << " ms" << endl;
//        cout << "\tRead bandwidth = " << bw << " Mbps" << endl << endl;
//
//		_snprintf_s(lines[2],sizeof(strbuf), _TRUNCATE, "Read bandwidth test #%d", n);
//		_snprintf_s(lines[3],sizeof(strbuf), _TRUNCATE, "\t%g Mbps", bw);
//		PostThreadMessage(dwDisplayThreadID, WM_PAINT, NULL, NULL);
//
//		while(!displayUpdated){
//			//busy wait until the display has been updated
//		}
//		displayUpdated = false;
//	}
//
//	cout << "\tBest write bandwidth = " << bestWrite << " Mbps" << endl;
//	cout << "\tBest read bandwidth = " << bestRead << " Mbps" << endl << endl;
 //HANDLE hFile; 
 //   char DataBuffer[] = "This is some test data to write to the file.";
 //   DWORD dwBytesToWrite = (DWORD)strlen(DataBuffer);
 //   DWORD dwBytesWritten = 0;
 //   BOOL bErrorFlag = FALSE;
 //  hFile = CreateFile("CounterData",                // name of the write
 //                      GENERIC_WRITE,          // open for writing
 //                      0,                      // do not share
 //                      NULL,                   // default security
 //                      CREATE_NEW,             // create new file only
 //                      FILE_ATTRIBUTE_NORMAL,  // normal file
 //                      NULL);                  // no attr. template
 //  for(int i=0;i<(N/32)*(N/32)*(N/32);i++)
 //  {
	//   string temp = countervalues[i];
	//   DataBuffer = (char*)temp.c_str();// + "\n";
	//   dwBytesToWrite = (DWORD)strlen(DataBuffer);
 //  bErrorFlag = WriteFile( 
 //                   hFile,           // open file handle
 //                   DataBuffer,      // start of data to write
 //                   dwBytesToWrite,  // number of bytes to write
 //                   &dwBytesWritten, // number of bytes that were written
 //                   NULL);            // no overlapped structure
 //  }
 //  CloseHandle(hFile);
 for(int i=0;i<(N/32)*(N/32);i++)
 {
	cout<< countervalues[i]<< "  ";
 }
	cin>>a;
	delete SIRC_P;
	delete [] matA;
	delete [] matB;
	delete [] matC;
	free(inputValues);
	free(outputValues);

#ifdef BUGHUNT
    StartLog(susp);
#endif
    PrintZeLog();
	return 0;
}
