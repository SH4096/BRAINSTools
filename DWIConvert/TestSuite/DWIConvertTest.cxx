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

#include <iostream>
#include "itkBRAINSToolsTestMain.h"
// #include "DWIConvert.cxx"

/*
extern "C" MODULE_IMPORT int ModuleEntryPoint(int, char* []);

void RegisterTests()
{
  StringToTestFunctionMap["ModuleEntryPoint"] = ModuleEntryPoint;
}
*/

void
RegisterTests()
{
  REGISTER_TEST(DWIConvertTest);
}

#undef main
#define main DWIConvertTest
#include "../DWIConvert.cxx"