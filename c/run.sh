#!/bin/bash

rm -rf main
gcc main.c -lcrypto -o main
clear
./main
