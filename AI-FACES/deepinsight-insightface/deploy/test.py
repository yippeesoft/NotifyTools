# coding=utf-8
import face_model
import argparse
import cv2
import sys
import numpy as np
import time

parser = argparse.ArgumentParser(description='face model test')
# general
parser.add_argument('--image-size', default='112,112', help='')
parser.add_argument('--model', default='../models/model,0', help='path to load model.')
parser.add_argument('--ga-model', default='', help='path to load model.')
parser.add_argument('--gpu', default=0, type=int, help='gpu id')
parser.add_argument('--det', default=0, type=int, help='mtcnn option, 1 means using R+O, 0 means detect from begining')
parser.add_argument('--flip', default=0, type=int, help='whether do lr flip aug')
parser.add_argument('--threshold', default=1.24, type=float, help='ver dist threshold')
args = parser.parse_args()

model = face_model.FaceModel(args)

def testlfw():
	lfw_root='X:\\face-data\lfw\\'
	pairs_txt='.\pairs_label.txt'
	file=open(pairs_txt)

	fout=open('y:\\temp\lfw_insi_test.csv','w+')

	outlines=''
	lines=file.readlines()
	file.close()

	for line in lines:
		try:
			path = line.strip('\n').split('\t')
		
			img = cv2.imread(lfw_root+path[0])
			img = model.get_input(img)
			f1 = model.get_feature(img)

			img = cv2.imread(lfw_root+path[1])
			img = model.get_input(img)
			f2 = model.get_feature(img)
			sim = np.dot(f1, f2.T)
			outlines=outlines+line.strip('\n').strip('\r')+','+str(sim).strip('\n')+'\n'
		except:
			print(lfw_root+path[0])

	fout.write(outlines)
	print('end!!!!!')
	cv2.waitKey()
	sys.exit(0)

def testlfw112():
	lfw_root='Y:\\tmp\mobileFacenet-ncnn-honghuCode\lfw-112X112\lfw-112X112\\'
	pairs_txt='Y:\\tmp\mobileFacenet-ncnn-honghuCode\pairs_1.txt'
	file=open(pairs_txt)

	fout=open('y:\\temp\lfw_out.csv','w+')

	outlines=''
	lines=file.readlines()
	file.close()

	for line in lines:
		try:
			path = line.strip('\n').split(',')
		
			img = cv2.imread(lfw_root+path[0])
			img = model.get_input(img)
			f1 = model.get_feature(img)

			img = cv2.imread(lfw_root+path[1])
			img = model.get_input(img)
			f2 = model.get_feature(img)
			sim = np.dot(f1, f2.T)
			outlines=outlines+line.strip('\n').strip('\r')+','+str(sim).strip('\n')+'\n'
		except:
			print(lfw_root+path[0])

	fout.write(outlines)
	print('end!!!!!')
	cv2.waitKey()
	sys.exit(0)

def old_src():
	img = cv2.imread('X:\pic\ll2.jpg')


	img = model.get_input(img)

	f1 = model.get_feature(img)
	print(f1[0:10])
	#gender, age = model.get_ga(img)
	#print(gender)
	#print(age)
	#sys.exit(0)
	img = cv2.imread('X:\pic\ll2.jpg')
	#cv2.imshow('ss',img)
	img = model.get_input(img)
	f2 = model.get_feature(img)
	dist = np.sum(np.square(f1-f2))
	print(dist)
	sim = np.dot(f1, f2.T)
	print(sim)
	cv2.waitKey(0)
	#diff = np.subtract(source_feature, target_feature)
	#dist = np.sum(np.square(diff),1)

def test_gcpu_time():
	img = cv2.imread('y:\ll1.bmp')
	img = model.get_input(img)
	now_milli_time = int(time.time() * 1000)
	for i in range(100):
		f1 = model.get_feature(img)
	now_milli_time2 = int(time.time() * 1000)
	print('1000 get_feature 耗时 {} ms \n'.format(now_milli_time2-now_milli_time))
	#print(f1[0:10])


if __name__ == "__main__":
	print('main begin')
	test_gcpu_time()
	print('main end')