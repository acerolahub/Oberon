/*GENERATED BY OBNC 0.16.1*/

#ifndef ORG_h
#define ORG_h

#include <obnc/Out.h>
#include <obnc/Files.h>
#include "ORS.h"
#include "ORB.h"
#include <obnc/OBNC.h>

#define ORG__WordSize_ 4

#define ORG__DEBUG_ 1

#define ORG__SOUTCHAR_ 1

#define ORG__SOUTSTRING_ 2

#define ORG__SOUTSTRINGLN_ 3

#define ORG__SOUTINT_ 4

#define ORG__SOUTINTFORMAT_ 5

#define ORG__SOUTHEX_ 6

#define ORG__SOUTREAL_ 7

#define ORG__SOUTREALFORMAT_ 8

#define ORG__SOUTLN_ 9

typedef struct ORG__Exit_ *ORG__Ptr_;

typedef struct ORG__Exit_ {
	OBNC_INTEGER label_;
	ORG__Ptr_ next_;
} ORG__Exit_;

struct ORG__Exit_Heap {
	const OBNC_Td *td;
	struct ORG__Exit_ fields;
};

#define ORG__Exit_id compiler__ORG__Exit_id
extern const int ORG__Exit_id;

#define ORG__Exit_ids compiler__ORG__Exit_ids
extern const int *const ORG__Exit_ids[1];

#define ORG__Exit_td compiler__ORG__Exit_td
extern const OBNC_Td ORG__Exit_td;

typedef struct ORG__Item_ {
	OBNC_INTEGER mode_;
	ORB__Type_ type_;
	OBNC_INTEGER a_, b_, r_;
	int rdo_;
	OBNC_INTEGER acc_;
	ORG__Ptr_ Lseq_;
	ORG__Ptr_ Lnext_;
	ORG__Ptr_ Lexit_;
	ORS__Ident_ name_;
} ORG__Item_;

struct ORG__Item_Heap {
	const OBNC_Td *td;
	struct ORG__Item_ fields;
};

#define ORG__Item_id compiler__ORG__Item_id
extern const int ORG__Item_id;

#define ORG__Item_ids compiler__ORG__Item_ids
extern const int *const ORG__Item_ids[1];

#define ORG__Item_td compiler__ORG__Item_td
extern const OBNC_Td ORG__Item_td;

typedef struct ORG__INSTRUCTION_ {
	unsigned char op_;
	OBNC_INTEGER a_, b_;
} ORG__INSTRUCTION_;

struct ORG__INSTRUCTION_Heap {
	const OBNC_Td *td;
	struct ORG__INSTRUCTION_ fields;
};

#define ORG__INSTRUCTION_id compiler__ORG__INSTRUCTION_id
extern const int ORG__INSTRUCTION_id;

#define ORG__INSTRUCTION_ids compiler__ORG__INSTRUCTION_ids
extern const int *const ORG__INSTRUCTION_ids[1];

#define ORG__INSTRUCTION_td compiler__ORG__INSTRUCTION_td
extern const OBNC_Td ORG__INSTRUCTION_td;

typedef struct ORG__SYSTEMCALLS_ {
	ORG__Item_ ops_[6];
} ORG__SYSTEMCALLS_;

struct ORG__SYSTEMCALLS_Heap {
	const OBNC_Td *td;
	struct ORG__SYSTEMCALLS_ fields;
};

#define ORG__SYSTEMCALLS_id compiler__ORG__SYSTEMCALLS_id
extern const int ORG__SYSTEMCALLS_id;

#define ORG__SYSTEMCALLS_ids compiler__ORG__SYSTEMCALLS_ids
extern const int *const ORG__SYSTEMCALLS_ids[1];

#define ORG__SYSTEMCALLS_td compiler__ORG__SYSTEMCALLS_td
extern const OBNC_Td ORG__SYSTEMCALLS_td;

#define ORG__pc_ compiler__ORG__pc_
#define ORG__pcbytes_ compiler__ORG__pcbytes_
#define ORG__varsize_ compiler__ORG__varsize_
extern OBNC_INTEGER ORG__pc_, ORG__pcbytes_, ORG__varsize_;

#define ORG__PUTLoadExtLong_ compiler__ORG__PUTLoadExtLong_
void ORG__PUTLoadExtLong_(OBNC_INTEGER op_, OBNC_INTEGER modnmb_, OBNC_INTEGER ofs_, OBNC_INTEGER acc_);

#define ORG__PUTLoadExt_ compiler__ORG__PUTLoadExt_
void ORG__PUTLoadExt_(OBNC_INTEGER op_, OBNC_INTEGER modnmb_, OBNC_INTEGER ofs_, OBNC_INTEGER acc_);

#define ORG__loadAdr_ compiler__ORG__loadAdr_
void ORG__loadAdr_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER acc_);

#define ORG__loadacc_ compiler__ORG__loadacc_
void ORG__loadacc_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER acc_);

#define ORG__SysCall_ compiler__ORG__SysCall_
void ORG__SysCall_(OBNC_INTEGER sys_);

#define ORG__FixAt_ compiler__ORG__FixAt_
void ORG__FixAt_(OBNC_INTEGER L0_, OBNC_INTEGER new_);

#define ORG__FixOr_ compiler__ORG__FixOr_
void ORG__FixOr_(OBNC_INTEGER L0_);

#define ORG__FixIf_ compiler__ORG__FixIf_
void ORG__FixIf_(OBNC_INTEGER *L0_);

#define ORG__FixList_ compiler__ORG__FixList_
void ORG__FixList_(ORG__Ptr_ p_);

#define ORG__FixNot_ compiler__ORG__FixNot_
void ORG__FixNot_(OBNC_INTEGER L_);

#define ORG__Here_ compiler__ORG__Here_
OBNC_INTEGER ORG__Here_(void);

#define ORG__JumpExit_ compiler__ORG__JumpExit_
void ORG__JumpExit_(void);

#define ORG__JumpWhile_ compiler__ORG__JumpWhile_
void ORG__JumpWhile_(OBNC_INTEGER L_);

#define ORG__JumpRepeat_ compiler__ORG__JumpRepeat_
void ORG__JumpRepeat_(ORG__Ptr_ p_, OBNC_INTEGER L_);

#define ORG__MakeConstItem_ compiler__ORG__MakeConstItem_
void ORG__MakeConstItem_(ORG__Item_ *x_, const OBNC_Td *x_td, ORB__Type_ typ_, OBNC_INTEGER val_);

#define ORG__MakeRealItem_ compiler__ORG__MakeRealItem_
void ORG__MakeRealItem_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_REAL val_);

#define ORG__MakeStringItem_ compiler__ORG__MakeStringItem_
void ORG__MakeStringItem_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER len_);

#define ORG__MakeItem_ compiler__ORG__MakeItem_
void ORG__MakeItem_(ORG__Item_ *x_, const OBNC_Td *x_td, ORB__Object_ y_, OBNC_INTEGER curlev_);

#define ORG__Field_ compiler__ORG__Field_
void ORG__Field_(ORG__Item_ *x_, const OBNC_Td *x_td, ORB__Object_ y_);

#define ORG__Index_ compiler__ORG__Index_
void ORG__Index_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__DeRef_ compiler__ORG__DeRef_
void ORG__DeRef_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__BuildTD_ compiler__ORG__BuildTD_
void ORG__BuildTD_(ORB__Type_ T_, OBNC_INTEGER *dc_);

#define ORG__TypeTest_ compiler__ORG__TypeTest_
void ORG__TypeTest_(ORG__Item_ *x_, const OBNC_Td *x_td, ORB__Type_ T_, int varpar_, int isguard_);

#define ORG__CopyPtrs_ compiler__ORG__CopyPtrs_
void ORG__CopyPtrs_(ORG__Ptr_ *x_, ORG__Ptr_ *y_);

#define ORG__AddPtr_ compiler__ORG__AddPtr_
void ORG__AddPtr_(ORG__Ptr_ *x_, OBNC_INTEGER L0_);

#define ORG__Not_ compiler__ORG__Not_
void ORG__Not_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__SubPtr_ compiler__ORG__SubPtr_
void ORG__SubPtr_(ORG__Ptr_ *x_, OBNC_INTEGER L0_);

#define ORG__And1_ compiler__ORG__And1_
void ORG__And1_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__And2_ compiler__ORG__And2_
void ORG__And2_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Or1_ compiler__ORG__Or1_
void ORG__Or1_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Or2_ compiler__ORG__Or2_
void ORG__Or2_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Neg_ compiler__ORG__Neg_
void ORG__Neg_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__AddOp_ compiler__ORG__AddOp_
void ORG__AddOp_(OBNC_INTEGER op_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__MulOp_ compiler__ORG__MulOp_
void ORG__MulOp_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__DivOp_ compiler__ORG__DivOp_
void ORG__DivOp_(OBNC_INTEGER op_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__RealOp_ compiler__ORG__RealOp_
void ORG__RealOp_(OBNC_INTEGER op_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Singleton_ compiler__ORG__Singleton_
void ORG__Singleton_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Set_ compiler__ORG__Set_
void ORG__Set_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__In_ compiler__ORG__In_
void ORG__In_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__SetOp_ compiler__ORG__SetOp_
void ORG__SetOp_(OBNC_INTEGER op_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__IntRealRelation_ compiler__ORG__IntRealRelation_
void ORG__IntRealRelation_(OBNC_INTEGER op_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__StringRelation_ compiler__ORG__StringRelation_
void ORG__StringRelation_(OBNC_INTEGER op_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Push_ compiler__ORG__Push_
void ORG__Push_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Pop_ compiler__ORG__Pop_
void ORG__Pop_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER acc_);

#define ORG__PushAdd_ compiler__ORG__PushAdd_
void ORG__PushAdd_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER L0_);

#define ORG__StrToChar_ compiler__ORG__StrToChar_
void ORG__StrToChar_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Store_ compiler__ORG__Store_
void ORG__Store_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__StoreStruct_ compiler__ORG__StoreStruct_
void ORG__StoreStruct_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__CopyString_ compiler__ORG__CopyString_
void ORG__CopyString_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__OpenArrayParam_ compiler__ORG__OpenArrayParam_
void ORG__OpenArrayParam_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__VarParam_ compiler__ORG__VarParam_
void ORG__VarParam_(ORG__Item_ *x_, const OBNC_Td *x_td, ORB__Type_ ftype_);

#define ORG__ValueParam_ compiler__ORG__ValueParam_
void ORG__ValueParam_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__StringParam_ compiler__ORG__StringParam_
void ORG__StringParam_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__For0_ compiler__ORG__For0_
void ORG__For0_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__For1_ compiler__ORG__For1_
void ORG__For1_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *z_, const OBNC_Td *z_td);

#define ORG__For2_ compiler__ORG__For2_
void ORG__For2_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *w_, const OBNC_Td *w_td);

#define ORG__PrepCall_ compiler__ORG__PrepCall_
void ORG__PrepCall_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER *r_);

#define ORG__Call_ compiler__ORG__Call_
void ORG__Call_(ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER r_);

#define ORG__Enter_ compiler__ORG__Enter_
void ORG__Enter_(OBNC_INTEGER parblksize_, OBNC_INTEGER locblksize_, OBNC_INTEGER *prevframe_);

#define ORG__Return_ compiler__ORG__Return_
void ORG__Return_(OBNC_INTEGER form_, ORG__Item_ *x_, const OBNC_Td *x_td, OBNC_INTEGER size_, OBNC_INTEGER prevframe_);

#define ORG__Increment_ compiler__ORG__Increment_
void ORG__Increment_(OBNC_INTEGER upordown_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Include_ compiler__ORG__Include_
void ORG__Include_(OBNC_INTEGER inorex_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Assert_ compiler__ORG__Assert_
void ORG__Assert_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__New_ compiler__ORG__New_
void ORG__New_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Pack_ compiler__ORG__Pack_
void ORG__Pack_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Unpk_ compiler__ORG__Unpk_
void ORG__Unpk_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Get_ compiler__ORG__Get_
void ORG__Get_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Put_ compiler__ORG__Put_
void ORG__Put_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Copy_ compiler__ORG__Copy_
void ORG__Copy_(void);

#define ORG__Abs_ compiler__ORG__Abs_
void ORG__Abs_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Odd_ compiler__ORG__Odd_
void ORG__Odd_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Floor_ compiler__ORG__Floor_
void ORG__Floor_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Float_ compiler__ORG__Float_
void ORG__Float_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Ord_ compiler__ORG__Ord_
void ORG__Ord_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Len_ compiler__ORG__Len_
void ORG__Len_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Shift_ compiler__ORG__Shift_
void ORG__Shift_(OBNC_INTEGER fct_, ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__ADC_ compiler__ORG__ADC_
void ORG__ADC_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__SBC_ compiler__ORG__SBC_
void ORG__SBC_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__UML_ compiler__ORG__UML_
void ORG__UML_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Bit_ compiler__ORG__Bit_
void ORG__Bit_(ORG__Item_ *x_, const OBNC_Td *x_td, ORG__Item_ *y_, const OBNC_Td *y_td);

#define ORG__Adr_ compiler__ORG__Adr_
void ORG__Adr_(ORG__Item_ *x_, const OBNC_Td *x_td);

#define ORG__Open_ compiler__ORG__Open_
void ORG__Open_(OBNC_INTEGER v_);

#define ORG__SetDataSize_ compiler__ORG__SetDataSize_
void ORG__SetDataSize_(OBNC_INTEGER dc_);

#define ORG__Header_ compiler__ORG__Header_
void ORG__Header_(void);

#define ORG__Init_ compiler__ORG__Init_
void ORG__Init_(void);

#define ORG__Close_ compiler__ORG__Close_
void ORG__Close_(ORS__Ident_ modid_, OBNC_INTEGER key_, OBNC_INTEGER nofent_);

#define ORG__Init compiler__ORG__Init
void ORG__Init(void);

#endif
