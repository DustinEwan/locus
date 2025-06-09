	.text
	.file	"wildcard_match_test.ll"
	.globl	test_number                     # -- Begin function test_number
	.p2align	4, 0x90
	.type	test_number,@function
test_number:                            # @test_number
	.cfi_startproc
# %bb.0:                                # %entry
	cmpl	$1, %edi
	jne	.LBB0_1
# %bb.3:                                # %match_arm_1
	movl	$100, %eax
	retq
.LBB0_1:                                # %match_test_2
	cmpl	$2, %edi
	jne	.LBB0_2
# %bb.4:                                # %match_arm_3
	movl	$200, %eax
	retq
.LBB0_2:                                # %match_test_4
	movl	$999, %eax                      # imm = 0x3E7
	retq
.Lfunc_end0:
	.size	test_number, .Lfunc_end0-test_number
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	$1, %edi
	callq	test_number@PLT
	movl	%eax, 16(%rsp)
	movl	$2, %edi
	callq	test_number@PLT
	movl	%eax, 12(%rsp)
	movl	$42, %edi
	callq	test_number@PLT
	movl	%eax, 20(%rsp)
	movl	16(%rsp), %ecx
	addl	12(%rsp), %ecx
	addl	%ecx, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
