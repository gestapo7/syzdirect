// -*- C++ -*-
//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// REQUIRES: modules-build

// WARNING: This test was generated by 'generate_private_header_tests.py'
// and should not be edited manually.

// expected-error@*:* {{use of private header from outside its module: '__iterator/back_insert_iterator.h'}}
#include <__iterator/back_insert_iterator.h>