### ActivityManagerService.startActivity --> startActivityAsUser(IApplicationThread caller, String callingPackage,Intent intent, String resolvedType, IBinder resultTo, String resultWho, int requestCode,int startFlags, ProfilerInfo profilerInfo, Bundle options, int userId)






### ActivityStackSupervisor.startActivityMayWait(IApplicationThread caller, int callingUid,String callingPackage, Intent intent, String resolvedType,IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor,IBinder resultTo, String resultWho, int requestCode, int startFlags,ProfilerInfo profilerInfo, WaitResult outResult, Configuration config,Bundle options, boolean ignoreTargetSecurity, int userId,IActivityContainer iContainer, TaskRecord inTask)





### ActivityStackSupervisor.startActivityLocked(IApplicationThread caller,Intent intent, String resolvedType, ActivityInfo aInfo,IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor,IBinder resultTo, String resultWho, int requestCode,int callingPid, int callingUid, String callingPackage,int realCallingPid, int realCallingUid, int startFlags, Bundle options,boolean ignoreTargetSecurity, boolean componentSpecified, ActivityRecord[] outActivity,ActivityContainer container, TaskRecord inTask)






###  ActivityStackSupervisor.startActivityUncheckedLocked(final ActivityRecord r, ActivityRecord sourceRecord,IVoiceInteractionSession voiceSession, IVoiceInteractor voiceInteractor, int startFlags,boolean doResume, Bundle options, TaskRecord inTask)






### ActivityStack.startActivityLocked(ActivityRecord r, boolean newTask,boolean doResume, boolean keepCurTransition, Bundle options)






### ActivityStackSupervisor.resumeTopActivitiesLocked(ActivityStack targetStack, ActivityRecord target,Bundle targetOptions)






### ActivityStack.resumeTopActivityLocked(ActivityRecord prev, Bundle options)







### ActivityStack.resumeTopActivityInnerLocked(ActivityRecord prev, Bundle options)







## ActivityStackSupervisorstartSpecificActivityLocked(ActivityRecord r,boolean andResume, boolean checkConfig)   






### ActivityStackSupervisor.realStartActivityLocked(ActivityRecord r,ProcessRecord app, boolean andResume, boolean checkConfig)

### ActivityThread.ApplicationThread.scheduleLaunchActivity(Intent intent, IBinder token, int ident,ActivityInfo info, Configuration curConfig, Configuration overrideConfig,CompatibilityInfo compatInfo, String referrer, IVoiceInteractor voiceInteractor,int procState, Bundle state, PersistableBundle persistentState,List<ResultInfo> pendingResults, List<ReferrerIntent> pendingNewIntents,boolean notResumed, boolean isForward, ProfilerInfo profilerInfo)

在这里通过handler发送H.LAUNCH_ACTIVITY消息调用handleLaunchActivity(r, null);


### ActivityThread.handleLaunchActivity(r, null)


### ActivityThread.performLaunchActivity(ActivityClientRecord r, Intent customIntent)
这里通过反射得到Activity实例.同时,如果Application对象为空,也是通过LoadedApk获得Application对象.
这里还有一句activity.attch()初始化了Window.

### Instrumentation.callActivityOnCreate(Activity activity, Bundle icicle)


### Activity.performCreate(Bundle icicle)



### Activity.onCreate(Bundle savedInstanceState)




### Activity.performStart()




### ActivitThread.handleResumeActivity(IBinder token,boolean clearHide, boolean isForward, boolean reallyResume)




### ActivityThread.performResumeActivity(IBinder token,boolean clearHide)




### Activity.performResume();



### Instrumentation.callActivityOnResume(Activity activity)
``` activity.onResume(); ````





### Activity.onResume()
