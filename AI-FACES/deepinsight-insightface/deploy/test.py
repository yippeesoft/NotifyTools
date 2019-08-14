#coding=utf-8
# -*- coding: utf-8 -*-
import os
import sys
reload(sys) 
sys.setdefaultencoding('utf-8')
import face_model
import argparse
import cv2
import sys
import numpy as np
import time
import json

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
	map={}
	map['aaa']=f1.tolist()
	print map
	print json.dumps(map)
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

def GetFileList(dir, fileList):
	newDir = dir
	if os.path.isfile(dir):
		fileList.append(dir.decode('utf-8'))
	elif os.path.isdir(dir): 
		for s in os.listdir(dir):
		#如果需要忽略某些文件夹，使用以下代码
		#if s == "xxx":	#continue
			newDir=os.path.join(dir,s)
		GetFileList(newDir, fileList) 
	return fileList
 

def all_path(dirname):
	resultall=[]
	resultsubdir = []#所有的文件
	resultsubdir=os.listdir(dirname)
	 
	for ii in range(len(resultsubdir)):
		#print('get '+resultsubdir[ii])
		resultfile=os.listdir(os.path.join(dirname, resultsubdir[ii]))
		fullname=os.path.join(dirname, resultsubdir[ii])
		fullnamee=os.path.join(fullname,resultfile[0])
		resultall.append(fullnamee)
		#print('get '+fullnamee)

	return resultall
	#for maindir, subdir, file_name_list in os.walk(dirname):

		#print("1:",maindir) #当前主目录
		#print("2:",subdir) #当前主目录下的所有目录
		#print("3:",file_name_list)  #当前主目录下的所有文件
		#apath = os.path.join(maindir, file_name_list[0])#合并成一个完整路径
		#print(apath+'\n')
		#for filename in file_name_list:
		#	apath = os.path.join(maindir, filename)#合并成一个完整路径
		#	result.append(apath)

	#return result


def get_all_lfw_feature():
	lst=all_path('X:\\face-data\lfw')
	map={}
	for picc in lst:
		img = cv2.imread('X:\pic\ll2.jpg')
		img = model.get_input(img)
		f1 = model.get_feature(img)
		map[picc]=f1.tolist()
	with open('y:\\temp\lfw.json', 'w') as json_file:
		json.dump(map, json_file)
	jsonn=json.dumps(map)
	fout=open('y:\\temp\lfw_insi.json','w+')
	fout.write(jsonn)
	fout.close()
	return lst

if __name__ == "__main__":
	print('main begin')
	#test_gcpu_time()
	all=[]
	all=get_all_lfw_feature()
	#old_src()
	print('main end ' )