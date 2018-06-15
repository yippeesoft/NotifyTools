#include "SeetaFace.h"
#include  <iostream>
using namespace std;
using namespace seeta;

int main(int argc, char* argv[]) {
 

	std::cout << "Detections takes start"  << std::endl;
    SeetaFace sf;
    std::cout << "Detections takes start2"  << std::endl;
	float *feat1 = sf.NewFeatureBuffer();
	float *feat2 = sf.NewFeatureBuffer();
	long t0 = cv::getTickCount();
	sf.GetFeature("ll_640x480.jpg", feat1);
	long t1 = cv::getTickCount();
	double secs = (t1 - t0) / cv::getTickFrequency();

	std::cout << "Detections takes " << secs << " seconds " << std::endl;
	t0 = cv::getTickCount();
	sf.GetFeature("ll2_640x480.jpg", feat2);
	  t1 = cv::getTickCount();
	  secs = (t1 - t0) / cv::getTickFrequency();

	std::cout << "Detections2 takes " << secs << " seconds " << std::endl;
	std::cout << "Similarity(0-1):" << sf.FeatureCompare(feat1, feat2) << std::endl;
 
	return 0;
}