//
//  PacketStruct.h
//  FCARD
//
//  Created by FREELANCER on 14-6-25.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#ifndef FCARD_PacketStruct_h
#define FCARD_PacketStruct_h

#define RESP 0x21
#define RESP_OK 0x01
#define RESP_ERROR_PWD 0x02
#define RESP_ERROR_CHECK 0x03

#define CARD_DATA_LENGTH 0x21

static char FLAG[] = {0x7e};
static char INFO_CODE[] = {0x13,0x10,0x03,0x19};
static char DEFAULT_PASSWORD[] = {0xff, 0xff, 0xff,0xff};
/**
 *@密码表
 */
typedef struct{
    /**权限**/
    char vilid;
    /**密码**/
    char pwd[4];
}MyOpenDoorPwdStruct;
/**
 *@密码列表
 */
typedef struct{
    char info[32];
    char length[4];
    MyOpenDoorPwdStruct mOdp[1];
}MyOpenDoorPwdListStruct;
/**
 *获取开门密码列表
 */
static char OPEN_DOOR_PWD_LIST_CONTROL[] = {0x05,0x03,0x00};
static char OPEN_DOOR_PWD_LIST_DATELENGTH[] = {0x00,0x00,0x00,0x00};
//删除开门密码
static char OPEN_DOOR_PWD_DEL_CONTROL[] = {0x05,0x05,0x00};
//增加开门密码
static char OPEN_DOOR_PWD_CONTROL[] = {0x05,0x04,0x00};
static char OPEN_DOOR_PWD_DATALENGTH[] = {0x00,0x00,0x00,0x09};

//开门
static char OPEN_DOOR_CONTROL[] = {0x03,0x03,0x00};
static char OPEN_DOOR_DATALENGTH[] = {0x00,0x00,0x00,0x04};

//添加授权卡
static char ADD_CARD_CONTROL[] = {0x07,0x04,0x00};
static char ADD_CRAD_DATALENGTH[] = {0x00,0x00,0x00,0x25};
static char ADD_CARD_COUNT[] = {0x00,0x00,0x00,0x01};
static char ADD_CARD_PASSWORD[]={0xff,0xff,0xff,0xff};
static char ADD_CRAD_OPEN_TIME[] = {0x01,0x01,0x01,0x01};
static char ADD_CARD_VILID_TIMES[] = {0xff,0xff};
static char ADD_CARD_STATUS[] ={0x00};
static char ADD_CARD_HOLIDAY[] = {0x00,0x00,0x00,0x00};
static char ADD_CARD_OI_FLAG[] = {0xff};
static char ADD_CARD_RECREAD_DATE[] = {0xff,0xff,0xff,0xff,0xff,0xff};

//删除授权卡
static char DEL_CARD_CONTROL[] = {0x07,0x05,0x00};
static char DEL_CARD_DATGALENGTH[] = {0x00,0x00,0x00,0x09};

//读取单个授权卡
static char READ_CARD_CONTROL[] = {0x07,0x03,0x01};
static char READ_CARD_DATALENGTH[] = {0x00,0x00,0x00,0x05};
typedef struct{
    char info[20];
    char right;
}MyCardStrcut;
//门口状态
static char DOOR_STATUS_CONTROL[] = {0x01,0x0e,0x00};
static char DOOR_STATUS_DATALENGTH[] = {0x00,0x00,0x00,0x00};

typedef struct
{
    char info[32];
    char reserved[4];
    char run_status[4];
    char door_switch[4]; //门磁开关 0关1开
    char door_alarm_status[4]; //门报警状态
                                //bit0 非法刷卡报警
                                //bit1 门磁铁报警
                                //bit2 胁迫报警
                                //bit3 开门超时报警
                                //bit4 黑名单报警
    char device_alarm_status;
    char jdq_status[8];
    char lock_status[4]; //0 未锁定 1 锁定
    char monitor_status; //0 未开启监控 1 开启监控
    char people_indoor[20];
    char host_status;
}MyPortStatusInfo;

//设备时间
static char DEVICE_TIME_READ_CONTROL[] = {0x02,0x01,0x00};
static char DEVICE_TIME_READ_DATALENGTH[] = {0x00,0x00,0x00,0x00};

typedef struct
{
    char info[32];
    char dev_date[7]; //ssmmHHddMMWWyy 秒分时日月周年
}MyDeviceDate;

static char DEVICE_TIME_WRITE_CONTROL[] = {0x02,0x02,0x00};
static char DEVICE_TIME_WRITE_DATALENGTH[] = {0x00,0x00,0x00,0x07};

//设备信息
static char DEVICE_INFO_CONTROL[] = {0x01,0x09,0x00};
static char DEVICE_INFO_DATELENGTH[] = {0x00,0x00,0x00,0x00};

static char FIRMWARE_CONTROL[] = {0x01,0x08,0x00};
static char FIREWARE_DATELENGTH[] = {0x00,0x00,0x00,0x00};

typedef struct
{
    char info[32];
    char run_days[2];//运行天数
    char format_times[2];
    char restore_times[2];
    char ups;
    char sys_temperature[2];//温度
    char start_date[7];
    char voltage[2];//电压
}MyDeviceInfo;

typedef struct
{
    char info[32];
    char fireware_version[4];//版本号、修正好各两字节 0x39393232 -> V99.22
}MyFireware;


//查询纪录
static char CHECK_RECORD_POINTER_CONTROL[] = {0x08,0x01,0x00};
static char CHECK_RECORD_POINTER_DATALENGTH[] = {0x00,0x00,0x00,0x00};

static char CHECK_RECORD_CONTROL[] = {0x08,0x04,0x00};
static char CHECK_RECORD_DATALENGTH[] = {0x00,0x00,0x00,0x09};

typedef struct
{
    char record_max[4];//纪录容量
    char record_num[4];//纪录尾号
    char upload[4];//上传断点
    char flag[1]; //循环标志
    
}MyRecordInfoStruct;
/*
    纪录指针信息
 **/
typedef struct
{
    char info[32];
    char read_card_record[13];
    char open_switch_record[13];
    char mc_record[13];
    char remote_open_record[13];
    char alarm_record[13];
    char system_record[13];
    
}MyRecordPointerStruct;
/**
 纪录内容
 */
typedef struct
{
    char record_index[4];
    char record_card_num[5];
    char record_date[6];
    char record_reader_index;
    char record_status;
    
}MyRecordContentStruct;
/**
 纪录格式
 */
typedef struct
{
    char info[32];
    char record_count[4];
    MyRecordContentStruct content[1]; // (4+5+6+1+1)*10
}MyRecordFormatSrtuct;

//读取防盗设置
static char READ_SECURITY_CONTROL[] = {0x01,0x0a,0x8e};
static char READ_SECURIY_DATALENGTH[] = {0x00,0x00,0x00,0x00};

typedef struct
{
    char info[32];
    char status;
    char in_delay_time;
    char out_delay_time;
    char set_password[4];
    char cancel_password[4];
    char alarm_time[2];
}MySecuritySetingStruct;

//防盗设置
static char SET_SECURITY_CONTROL[] = {0x01,0x0a,0x0e};
static char SET_SECURIY_DATALENGTH[] = {0x00,0x00,0x00,0x0d};

#endif
