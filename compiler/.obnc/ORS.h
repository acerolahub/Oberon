/*GENERATED BY OBNC 0.16.1*/

#ifndef ORS_h
#define ORS_h

#include <obnc/Out.h>
#include <obnc/Files.h>
#include <obnc/OBNC.h>

#define ORS__IdLen_ 32

#define ORS__times_ 1

#define ORS__rdiv_ 2

#define ORS__div_ 3

#define ORS__mod_ 4

#define ORS__and_ 5

#define ORS__plus_ 6

#define ORS__minus_ 7

#define ORS__or_ 8

#define ORS__eql_ 9

#define ORS__neq_ 10

#define ORS__lss_ 11

#define ORS__leq_ 12

#define ORS__gtr_ 13

#define ORS__geq_ 14

#define ORS__in_ 15

#define ORS__is_ 16

#define ORS__arrow_ 17

#define ORS__period_ 18

#define ORS__char_ 20

#define ORS__int_ 21

#define ORS__real_ 22

#define ORS__false_ 23

#define ORS__true_ 24

#define ORS__nil_ 25

#define ORS__string_ 26

#define ORS__not_ 27

#define ORS__lparen_ 28

#define ORS__lbrak_ 29

#define ORS__lbrace_ 30

#define ORS__ident_ 31

#define ORS__if_ 32

#define ORS__while_ 34

#define ORS__repeat_ 35

#define ORS__case_ 36

#define ORS__for_ 37

#define ORS__comma_ 40

#define ORS__colon_ 41

#define ORS__becomes_ 42

#define ORS__upto_ 43

#define ORS__rparen_ 44

#define ORS__rbrak_ 45

#define ORS__rbrace_ 46

#define ORS__then_ 47

#define ORS__of_ 48

#define ORS__do_ 49

#define ORS__to_ 50

#define ORS__by_ 51

#define ORS__semicolon_ 52

#define ORS__end_ 53

#define ORS__bar_ 54

#define ORS__else_ 55

#define ORS__elsif_ 56

#define ORS__until_ 57

#define ORS__return_ 58

#define ORS__array_ 60

#define ORS__record_ 61

#define ORS__pointer_ 62

#define ORS__const_ 63

#define ORS__type_ 64

#define ORS__var_ 65

#define ORS__procedure_ 66

#define ORS__begin_ 67

#define ORS__import_ 68

#define ORS__module_ 69

typedef char ORS__Ident_[32];

#define ORS__ival_ compiler__ORS__ival_
#define ORS__slen_ compiler__ORS__slen_
extern OBNC_INTEGER ORS__ival_, ORS__slen_;

#define ORS__rval_ compiler__ORS__rval_
extern OBNC_REAL ORS__rval_;

#define ORS__id_ compiler__ORS__id_
extern ORS__Ident_ ORS__id_;

#define ORS__str_ compiler__ORS__str_
extern char ORS__str_[256];

#define ORS__errcnt_ compiler__ORS__errcnt_
extern OBNC_INTEGER ORS__errcnt_;

#define ORS__Init_ compiler__ORS__Init_
void ORS__Init_(Files__File_ F_, OBNC_INTEGER pos_);

#define ORS__Pos_ compiler__ORS__Pos_
OBNC_INTEGER ORS__Pos_(void);

#define ORS__Mark_ compiler__ORS__Mark_
void ORS__Mark_(const char msg_[], OBNC_INTEGER msg_len);

#define ORS__CopyId_ compiler__ORS__CopyId_
void ORS__CopyId_(ORS__Ident_ ident_);

#define ORS__Get_ compiler__ORS__Get_
void ORS__Get_(OBNC_INTEGER *sym_);

#define ORS__Init compiler__ORS__Init
void ORS__Init(void);

#endif