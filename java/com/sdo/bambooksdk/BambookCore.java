package com.sdo.bambooksdk;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.ptr.IntByReference;

public interface BambookCore extends Library {
    /**
     * 功能：取得SDK DLL版本号
     * 参数：version: 指针，返回版本号
     * 返回：成功返回 BR_SUCC
     * 注释：调用该函数可以返回DLL支持SDK版本号，可用于兼容性处理
     */
    public int BambookGetSDKVersion(IntByReference version);

    /**
     * 功能：连接Bambook设备
     * 参数：lpszIP: Bambook IP地址，传空时使用默认值 DEFAULT_BAMBOOK_IP
     *       timeOut: 超时值，单位毫秒，0为默认
     *       hConn: 句柄指针，执行成功返回连接句柄
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL，超时返回 BR_TIMEOUT
     * 注释：调用函数后会阻塞执行，连接成功后 hConn 为连接句柄。
     *       连接被中断或通讯结束后应调用 BambookDisconnect 释放资源
     */
    public int BambookConnect(String lpszIP, int timeOut, IntByReference hConn);

    /**
     * 功能：断开Bambook设备的连接
     * 参数：hConn: 连接句柄
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL
     * 注释：调用函数后会阻塞执行，直到连接被断开或失败，成功后 hConn 句柄将不可用
     */
    public int BambookDisconnect(int hConn);

    /**
     * 功能：查询当前Bambook设备的连接状态
     * 参数：hConn: 连接句柄
     *       status: 指针，返回连接状态
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL
     * 注释：应用在调用其它API前可调用该函数以查询连接状态
     */
    public int BambookGetConnectStatus(int hConn, IntByReference status);

    /**
     * 功能：获取Bambook基本信息
     * 参数：hConn: 连接句柄
     *       pInfo: 信息指针，用于返回基本信息。调用前应设置 pInfo->cbSize = SizeOf(DeviceInfo)
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL 或错误原因代码
     *       如果 pInfo->cbSize 不正确将返回 BR_PARAM_ERROR
     * 注释：调用函数后会阻塞执行，直到操作成功或失败
     */
    public int BambookGetDeviceInfo(int hConn, DeviceInfo pInfo);

    /**
     * 功能：获取Bambook第一本自有书信息
     * 参数：hConn: 连接句柄
     *       pInfo: 信息指针，用于返回自有书信息。调用前应设置 pInfo->cbSize = SizeOf(PrivBookInfo)
     * 返回：成功返回 BR_SUCC，如果找不到自有书返回 BR_EOF，其它错误返回错误代码
     * 注释：调用该函数后将从头开始从设备查找自有书信息，成功后可以再次调用 BambookGetNextPrivBookInfo
     *       查找剩下的自有书信息。该函数会阻塞执行，直到操作成功或失败
     */
    public int BambookGetFirstPrivBookInfo(int hConn, PrivBookInfo pInfo);

    /**
     * 功能：获取Bambook下一本自有书信息
     * 参数：hConn: 连接句柄
     *       pInfo: 信息指针，用于返回自有书信息。调用前应设置 pInfo->cbSize = SizeOf(PrivBookInfo)
     * 返回：成功返回 BR_SUCC，如果找不到自有书返回 BR_EOF，其它错误返回错误代码
     * 注释：在调用 BambookGetFirstPrivBookInfo 成功后再调用本函数，查找后继的自有书信息。
     *       该函数会阻塞执行，直到操作成功或失败
     */
    public int BambookGetNextPrivBookInfo(int hConn, PrivBookInfo pInfo);

    /**
     * 功能：向Bambook传输自有书，传到Bambook以后的书籍ID为随机生成的字串
     * 参数：hConn: 连接句柄
     *       pszSnbFile: 自有书全路径文件名
     *       pCallbackFunc: 传输过程中回调函数，回调函数将在单独的线程中执行
     *       userData: 在回调中传回
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL 或错误原因代码
     * 注释：调用该函数后立即返回。如果调用成功，传输过程会调用回调函数通知状态和进度
     */
    public int BambookAddPrivBook(int hConn, String pszSnbFile, TransCallback pCallbackFunc, int userData);

    /**
     * 功能：向Bambook传输自有书，并指定书籍ID，书籍ID长度大于0不得超过char[20]
     *       ID为英文和字母，最后三位为".snb"。
     *       本函数可以用于替换Bambook内特定书籍。
     * 参数：hConn: 连接句柄
     *       pszSnbFile: 自有书全路径文件名
     *       lpszBookID: 书籍ID
     *       pCallbackFunc: 传输过程中回调函数，回调函数将在单独的线程中执行
     *       userData: 在回调中传回
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL 或错误原因代码
     * 注释：调用该函数后立即返回。如果调用成功，传输过程会调用回调函数通知状态和进度
     */
    public int BambookReplacePrivBook(int hConn, String pszSnbFile, String lpszBookID, TransCallback pCallbackFunc, int userData);

    /**
     * 功能：删除Bambook自有书
     * 参数：hConn: 连接句柄
     *       lpszBookID: 对应自有书信息中的 bookGuid
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL 或错误原因代码
     * 注释：只是发送删除命令，极端情况下可能会失败
     */
    public int BambookDeletePrivBook(int hConn, String lpszBookID);

    /**
     * 功能：向Bambook请求自有书文件
     * 参数：hConn: 连接句柄
     *       lpszBookID: 对应自有书信息中的 bookGuid
     *       lpszFilePath: 接收自有书文件存放目录
     *       pCallbackFunc: 传输过程中回调函数，回调函数将在单独的线程中执行
     *       userData: 在回调中传回
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL 或错误原因代码
     * 注释：调用该函数后立即返回。如果调用成功，传输过程会调用回调函数通知状态和进度
     */
    public int BambookFetchPrivBook(int hConn, String lpszBookID, String lpszFilePath, TransCallback pCallbackFunc, int userData);

    /**
     * 功能：向Bambook发送按键命令
     * 参数：hConn: 连接句柄
     *       key: 按键值
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL 或错误原因代码
     */
    public int BambookKeyPress(int hConn, int key);

    /**
     * 功能：把一个符合 SNB 目录结构的目录打成 SNB 包
     * 参数：snbName: 生成的 snb 文件名
     *       rootDir: 要打包的根目录
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL、BR_IO_ERROR 或错误原因代码
     */
    public int BambookPackSnbFromDir(String snbName, String rootDir);

    /**
     * 功能：根据相对路径文件名从 SNB 包中解出一个文件
     * 参数：snbName: 要操作的 snb 文件名
     *       relativePath: 要解压的文件在包中的相对路径和文件名，比如："snbf/book.snbf"
     *       outputName: 解压出来的文件保存的全路径文件名
     * 返回：成功返回 BR_SUCC，失败返回 BR_FAIL、BR_IO_ERROR、BR_FILE_NOT_INSIDE 或错误原因代码
     */
    public int BambookUnpackFileFromSnb(String snbName, String relativePath, String outputName);

    /**
     * 功能：检查一个文件是否合法的 SNB 文件
     * 参数：snbName: 要操作的 snb 文件名
     * 返回：如果文件合法 BR_SUCC，否则返回 BR_INVALID_FILE 或错误原因代码
     */
    public int BambookVerifySnbFile(String snbName);

    /**
     * 功能：返回错误码对应的中文含义
     * 参数：nCode: 错误代码
     * 返回：错误信息字符串指针
     * 注释：该函数用来取得错误字符串，如果传入未定义的错误代码，将返回 "未知错误"
     */
    public String BambookGetErrorString(int nCode);
}
