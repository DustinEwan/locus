	.text
	.file	"simple_match_test.ll"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	movl	$0, -4(%rsp)
	movl	$0, -8(%rsp)
	xorl	%eax, %eax
	testb	%al, %al
	je	.LBB0_1
# %bb.2:                                # %match_test_2
	movb	$1, %al
	testb	%al, %al
	jne	.LBB0_4
# %bb.3:                                # %match_arm_3
	movl	$2, -8(%rsp)
	movl	-8(%rsp), %eax
	retq
.LBB0_1:                                # %match_arm_1
	movl	$1, -8(%rsp)
	movl	-8(%rsp), %eax
	retq
.LBB0_4:                                # %match_test_4
	jne	.LBB0_6
# %bb.5:                                # %match_arm_5
	movl	$3, -8(%rsp)
.LBB0_6:                                # %match_end_0
	movl	-8(%rsp), %eax
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
