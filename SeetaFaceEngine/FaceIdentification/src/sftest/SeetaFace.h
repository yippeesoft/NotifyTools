#pragma once
#include <string>
#include<iostream>
using std::string;
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include "face_detection.h"
#include "face_alignment.h"
#include "face_identification.h"
#include "opencv2/opencv.hpp"
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include "opencv2/imgproc/imgproc.hpp"
#include "face_identification.h"
#include "common.h"
#include <opencv2/imgproc/imgproc.hpp>

class Detector : public seeta::FaceDetection {
public:
	Detector(const char * model_name);
};

class SeetaFace {
public:
	SeetaFace();
	Detector* detector;
	seeta::FaceAlignment* point_detector;
	seeta::FaceIdentification* face_recognizer;
	bool GetFeature(string filename, float* feat);
	float* NewFeatureBuffer();
	float FeatureCompare(float* feat1, float* feat2);
	int GetFeatureDims();
};
