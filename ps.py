#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import psutil
import time

def getProcess(pName):
    all_pids  = psutil.pids()

    process_lst = []
    for pid in all_pids:
        p = psutil.Process(pid)
        if (p.name() == pName):
            process_lst.append(p)

    return process_lst

name_str="java"

#---------------cpu
print '# TYPE process_cpu_percent gauge'

for name in name_str.split(','):
  p_lst = getProcess(name)

  # Get cpu used percent of processes in top flush time
  t_list = []
  n=0
  for p in p_lst:
    for i in range(50):
        p_cpu = p.cpu_percent(interval=0.1)
        t_list.append(p_cpu)

    p_memory = round(p.memory_percent(),3)
    p_pid = ( p.pid )

    if(len(p_lst)==1):
      print 'process_cpu_percent{mode="%s"} %s'%(name,round(float(sum(t_list))/len(t_list),3))
    else:
      n=n+1
      print 'process_cpu_percent{mode="%s_%s_%s"} %s'%(name,n,p_pid,round(float(sum(t_list))/len(t_list),3))

#---------------memory
print ''
print '# TYPE process_memory_percent gauge'

for name in name_str.split(','):
  p_lst = getProcess(name)

  # Get memory used percent of processes in top flush time
  t_list = []
  n=0
  for p in p_lst:
    p_memory = round(p.memory_percent(),3)
    p_pid = ( p.pid )

    if(len(p_lst)==1):
      print 'process_memory_percent{mode="%s"} %s'%(name,p_memory)
    else:
      n=n+1
      print 'process_memory_percent{mode="%s_%s_%s"} %s'%(name,n,p_pid,p_memory)
