; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu    -global-isel -verify-machineinstrs -global-isel-abort=2 < %s -o - | FileCheck %s --check-prefix=X64

; TODO merge with ext.ll after i64 sext supported on 32bit platform

define i64 @test_zext_i1(i8 %a) {
; X64-LABEL: test_zext_i1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andq $1, %rax
; X64-NEXT:    retq
  %val = trunc i8 %a to i1
  %r = zext i1 %val to i64
  ret i64 %r
}

define i64 @test_sext_i8(i8 %val) {
; X64-LABEL: test_sext_i8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlq $56, %rax
; X64-NEXT:    sarq $56, %rax
; X64-NEXT:    retq
  %r = sext i8 %val to i64
  ret i64 %r
}

define i64 @test_sext_i16(i16 %val) {
; X64-LABEL: test_sext_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlq $48, %rax
; X64-NEXT:    sarq $48, %rax
; X64-NEXT:    retq
  %r = sext i16 %val to i64
  ret i64 %r
}

define i64 @test_sext_i32(i32 %val) {
; X64-LABEL: test_sext_i32:
; X64:       # %bb.0:
; X64-NEXT:    movslq %edi, %rax
; X64-NEXT:    retq
  %r = sext i32 %val to i64
  ret i64 %r
}

define i64 @test_zext_i8_to_i64(i8 %x, i8 %y) {
; X64-LABEL: test_zext_i8_to_i64:
; X64:       # %bb.0:
; X64-NEXT:    addb %dil, %sil
; X64-NEXT:    movzbl %sil, %eax
; X64-NEXT:    retq
  %a = add i8 %x, %y
  %b = zext i8 %a to i64
  ret i64 %b
}

define i64 @test_zext_i16_to_i64(i16 %x, i16 %y) {
; X64-LABEL: test_zext_i16_to_i64:
; X64:       # %bb.0:
; X64-NEXT:    addw %di, %si
; X64-NEXT:    movzwl %si, %eax
; X64-NEXT:    retq
  %a = add i16 %x, %y
  %b = zext i16 %a to i64
  ret i64 %b
}

define i64 @test_zext_i32_to_i64(i32 %x, i32 %y) {
; X64-LABEL: test_zext_i32_to_i64:
; X64:       # %bb.0:
; X64-NEXT:    addl %edi, %esi
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    retq
  %a = add i32 %x, %y
  %b = zext i32 %a to i64
  ret i64 %b
}