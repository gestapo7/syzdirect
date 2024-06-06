; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

; int foo() {
; struct V { char buf1[10];
;            int b;
;            char buf2[10];
;           } var;
;
;           char *p = &var.buf1[1];
;           return __builtin_object_size (p, 0);
; }

%struct.V = type { [10 x i8], i32, [10 x i8] }

define i32 @foo() #0 {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    ret i32 27
;
  %var = alloca %struct.V, align 4
  %t0 = bitcast %struct.V* %var to i8*
  call void @llvm.lifetime.start.p0i8(i64 28, i8* %t0) #3
  %buf1 = getelementptr inbounds %struct.V, %struct.V* %var, i32 0, i32 0
  %arrayidx = getelementptr inbounds [10 x i8], [10 x i8]* %buf1, i64 0, i64 1
  %t1 = call i64 @llvm.objectsize.i64.p0i8(i8* %arrayidx, i1 false)
  %conv = trunc i64 %t1 to i32
  call void @llvm.lifetime.end.p0i8(i64 28, i8* %t0) #3
  ret i32 %conv
}

; This used to crash while erasing instructions:
; https://bugs.llvm.org/show_bug.cgi?id=43723

define void @PR43723() {
; CHECK-LABEL: @PR43723(
; CHECK-NEXT:    ret void
;
  %tab = alloca [10 x i8], align 16
  %t0 = bitcast [10 x i8]* %tab to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %t0, i8 9, i64 10, i1 false)
  %t1 = call {}* @llvm.invariant.start.p0i8(i64 10, i8* align 16 %t0)
  call void @llvm.invariant.end.p0i8({}* %t1, i64 10, i8* align 16 %t0)
  ret void

  uselistorder i8* %t0, { 1, 0, 2 }
}

define void @unknown_use_of_invariant_start({}** %p) {
; CHECK-LABEL: @unknown_use_of_invariant_start(
; CHECK-NEXT:    ret void
;
  %tab = alloca [10 x i8], align 16
  %t0 = bitcast [10 x i8]* %tab to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %t0, i8 9, i64 10, i1 false)
  %t1 = call {}* @llvm.invariant.start.p0i8(i64 10, i8* align 16 %t0)
  call void @llvm.invariant.end.p0i8({}* %t1, i64 10, i8* align 16 %t0)
  store {}* %t1, {}** %p
  ret void
}

define {}* @minimal_invariant_start_use(i8 %x) {
; CHECK-LABEL: @minimal_invariant_start_use(
; CHECK-NEXT:    ret {}* poison
;
  %a = alloca i8
  %i = call {}* @llvm.invariant.start.p0i8(i64 1, i8* %a)
  ret {}* %i
}

declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1
declare i64 @llvm.objectsize.i64.p0i8(i8*, i1) #2
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0
declare {}* @llvm.invariant.start.p0i8(i64 immarg, i8* nocapture) #0
declare void @llvm.invariant.end.p0i8({}*, i64 immarg, i8* nocapture) #0