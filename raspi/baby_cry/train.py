# -*- coding:utf-8 -*-

from scikits.talkbox.features import mfcc
import numpy as np
import soundfile as sf
import os
from sklearn.ensemble import RandomForestClassifier
# from sklearn.svm import LinearSVC, SVC
# from xgboost import XGBClassifier
from sklearn.externals import joblib

from utils import import_wav_data_in_dir

random_state=24
label_dict = {'hu':0, 'ti':1, 'dc':2}
datapath = 'cry_data/devided_wav_data/'


def main():
    # import wav files
    files = import_wav_data_in_dir(datapath)

    # prepare for training
    # get feature vectors by mfcc
    X = []
    y = []
    for f in files:
        x, sample_rate = sf.read(datapath + f)
        x = np.clip(x, 1e-10, 1)
        ceps,mspec,spec = mfcc(x, nwin=256, nfft=512, fs=8000, nceps=13)
        X.append(np.mean(ceps, axis=0))
        if '-hu.' in f:
            y.append(label_dict['hu'])
        elif '-ti.' in f:
            y.append(label_dict['ti'])
        else:
            y.append(label_dict['dc'])

    X = np.array(X)
    y = np.array(y)

    # training
    clf = RandomForestClassifier(n_estimators=498, random_state=random_state)
    # clf = XGBClassifier(max_depth=8, learning_rate=0.05, n_estimators=700, seed=random_state)
    clf.fit(X, y)

    # save model
    joblib.dump(clf, 'trained_models/clf_rf2.pkl.cmp', compress=True)


if __name__ == '__main__':
    main()
