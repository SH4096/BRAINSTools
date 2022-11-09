/*=========================================================================
 *
 *  Copyright SINAPSE: Scalable Informatics for Neuroscience, Processing and Software Engineering
 *            The University of Iowa
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0.txt
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *=========================================================================*/
/*
 * Author: Wei Lu
 * at Psychiatry Imaging Lab,
 * University of Iowa Health Care 2010
 */

#ifndef __Cjyx3LandmarkIO__h
#define __Cjyx3LandmarkIO__h

#include "itkPoint.h"
#include <itksys/SystemTools.hxx>

#include <fstream>
#include <map>
#include <string>

#include <BRAINSTypes.h>

/*
 * This IO utility program transforms between ITK landmarks (in LPS coordinate
 * system) to Cjyx3 landmarks (in RAS coordinate system).
 */


/**
 * @brief enumeration for selecting different FCSV file formats.
 */
using CJYX_LANDMARK_FILE_TYPE = enum CJYX_LANDMARK_FILE_ENUMERATION {
  CJYX_FCSV_BEGIN = 0,
  CJYX_V3_FCSV = 1,
  CJYX_V4_FCSV = 2,
  CJYX_FCSV_END = 3
};

/*
 * Read lmk weights
 * weightFilename  -
 * Output: A map of weights
 */
LandmarksWeightMapType
ReadLandmarkWeights(const std::string & weightFilename);

/*
 * Write ITK landmarks to a Cjyx3 landmark list file (.fcsv)
 * Input:
 * landmarksFilename  - the filename of the output Cjyx landmark list file
 * landmarks          - a map of landmarks (itkPoints) to be written into file
 *
 * Output:
 * NONE
 */
extern void
WriteITKtoCjyx3Lmk(const std::string &             landmarksFilename,
                     const LandmarksMapType &        landmarks,
                     const CJYX_LANDMARK_FILE_TYPE cjyxLmkType = CJYX_V4_FCSV);

/*
 * Read Cjyx3 landmark list file (.fcsv) into a map of ITK points
 * Input:
 * landmarksFilename  - the filename of the input Cjyx landmark list file
 *
 * Output:
 * landmarks          - a map of itkPoints to save the landmarks in ITK
 */
extern LandmarksMapType
ReadCjyx3toITKLmk(const std::string & landmarksFilename);

#endif
