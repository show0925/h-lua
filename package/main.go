package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"./php2go"
)

func getCodes(flip string, allCodes string) string {
	codes, err := php2go.FileGetContents(flip)
	if err != nil {
		return allCodes
	}
	codes = php2go.StrReplace("\r\n", "\n", codes, -1)
	codes = php2go.StrReplace("\r", "\n", codes, -1)
	re, _ := regexp.Compile(`--(.*)\[\[[\s\S]*?\]\]`)
	codes = re.ReplaceAllString(codes, "")
	re, _ = regexp.Compile("--(.*)")
	codes = re.ReplaceAllString(codes, "")
	re, _ = regexp.Compile(`if \(HLUA_DEBUG == true\) then(.*)[\s\S]*?console"\send`)
	codes = re.ReplaceAllString(codes, "")
	re, _ = regexp.Compile("package.path(.*)")
	codes = re.ReplaceAllString(codes, "")
	//
	split := php2go.Explode("\n", codes)
	for _, f := range split {
		if len(f) > 0 {
			reSub, _ := regexp.Compile("^require (.*)")
			sub := reSub.FindSubmatch([]byte(f))
			if len(sub) == 0 {
				f = php2go.StrReplace("HLUA_DEBUG = true", "HLUA_DEBUG = false", f, -1)
				f = php2go.StrReplace("HLUA_DEBUG = TRUE", "HLUA_DEBUG = false", f, -1)
				f = php2go.StrReplace("HLUA_DEBUG=true", "HLUA_DEBUG = false", f, -1)
				f = php2go.StrReplace("HLUA_DEBUG=TRUE", "HLUA_DEBUG = false", f, -1)
				allCodes = allCodes + f + "\n"
			} else {
				//require
				sub2 := string(sub[1])
				load := sub2[1 : len(sub2)-1]
				load = php2go.Trim(load, " ")
				load = php2go.StrReplace(".", "/", load, -1) + ".lua"
				fmt.Println(load)
				for _, ip := range iniPaths {
					allCodes = getCodes(ip+"/"+load, allCodes)
				}
			}
		}
	}
	return allCodes
}

var (
	iniRawData map[string]string
	iniPaths   []string
)

func init() {
	iniRawData = make(map[string]string)
}

func main() {
	pwd, _ := os.Getwd()
	content, err := php2go.FileGetContents(pwd + "/package.ini")
	if err != nil {
		panic(err)
	}
	content = php2go.StrReplace("\r\n", "\n", content, -1)
	content = php2go.StrReplace("\r", "\n", content, -1)
	split := php2go.Explode("\n", content)
	allCodes := ""
	for _, iniItem := range split {
		if len(iniItem) > 0 {
			itemSplit := strings.Split(iniItem, "=")
			itemKey := itemSplit[0]
			iniRawData[itemKey] = itemSplit[1]
		}
	}
	iniPaths = php2go.Explode(",", iniRawData["paths"])
	allCodes = getCodes(iniRawData["index"], allCodes)
	distPath := filepath.Dir(iniRawData["index"])
	f, err := os.Create(distPath + "/dist.lua")
	defer f.Close()
	if err != nil {
		// 创建文件失败处理

	} else {
		_, err = f.Write([]byte(allCodes))
		if err != nil {
			panic(err)
		}
	}
	fmt.Println("打包dist.lua完成，按任意键退出...")
	input := bufio.NewScanner(os.Stdin)
	for input.Scan() {
		break
	}
}
