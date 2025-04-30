function rename_sequential_dir
    set target_dir $argv[1]
    
    # 현재 디렉토리 저장
    set current_dir (pwd)
    
    # 해당 디렉토리로 이동
    cd "$target_dir"
    
    echo "처리 중: $target_dir"
    
    # 파일 개수 확인
    set file_count (count (find . -maxdepth 1 -type f))
    
    # 포맷 결정
    set format "%d"
    if test $file_count -ge 10 -a $file_count -lt 100
        set format "%02d"
    else if test $file_count -ge 100 -a $file_count -lt 1000
        set format "%03d"
    else if test $file_count -ge 1000
        set format "%04d"
    end
    
    # 파일 이름 변경
    set counter 1
    for file in *
        if test -f "$file"
            # 확장자 추출 (없을 경우 대비)
            set parts (string split -r -m1 . "$file")
            if test (count $parts) -gt 1
                set new_name (printf "$format.%s" $counter $parts[2])
            else
                set new_name (printf "$format" $counter)
            end
            
            # 이름 변경
            mv "$file" "$new_name"
            set counter (math $counter + 1)
        end
    end
    
    # 하위 디렉토리 처리
    for dir in */
        if test -d "$dir"
            # 슬래시 제거
            set dirname (string trim -r -c '/' -- "$dir")
            
            # 전체 경로 계산
            set full_path "$target_dir/$dirname"
            
            # 재귀 호출
            rename_sequential_dir "$full_path"
        end
    end
    
    # 원래 디렉토리로 복귀
    cd "$current_dir"
end

function rename_sequential
    # 현재 디렉토리의 절대 경로 구하기
    set start_dir (realpath .)
    rename_sequential_dir "$start_dir"
end