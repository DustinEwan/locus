	.text
	.file	"comprehensive_match_test.ll"
	.globl	test_color                      # -- Begin function test_color
	.p2align	4, 0x90
	.type	test_color,@function
test_color:                             # @test_color
	.cfi_startproc
# %bb.0:                                # %entry
	testl	%edi, %edi
	je	.LBB0_4
# %bb.1:                                # %match_test_2
	cmpl	$1, %edi
	jne	.LBB0_2
# %bb.5:                                # %match_arm_3
	movl	$20, %eax
	retq
.LBB0_4:                                # %match_arm_1
	movl	$10, %eax
	retq
.LBB0_2:                                # %match_test_4
	cmpl	$2, %edi
	jne	.LBB0_3
# %bb.6:                                # %match_arm_5
	movl	$30, %eax
	retq
.LBB0_3:                                # %match_end_0
.Lfunc_end0:
	.size	test_color, .Lfunc_end0-test_color
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
	xorl	%edi, %edi
	callq	test_color@PLT
	movl	%eax, 16(%rsp)
	movl	$1, %edi
	callq	test_color@PLT
	movl	%eax, 12(%rsp)
	movl	$2, %edi
	callq	test_color@PLT
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
