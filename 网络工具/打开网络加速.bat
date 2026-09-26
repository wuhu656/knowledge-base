@echo off
chcp 936 >nul
title Network
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0net-switch.ps1" -Mode On
