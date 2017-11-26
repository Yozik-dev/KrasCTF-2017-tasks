(module
  (memory (export "credentials") 1)
  (func $compute_index_symbol (param $index i32) (result i32)
    (local $index_symbol_word i32)
    (set_local $index_symbol_word
      ;; word = words[index mod 4 => 2 least significant bits]
      (block $switch (result i32)
        (block $3
          (block $2
            (block $1
              (block $0
                (br_table $0 $1 $2 $3 (i32.and (get_local $index) (i32.const 3))))
              ;; 0, 4, 8, 12 => 0x7AB03B10
              (br $switch (i32.const 2058369808)))
            ;; 1, 5, 9, 13 => 0xB8C9EFA0
            (br $switch (i32.const 3100241824)))
          ;; 2, 6, 10, 14 => 0x7E2B17EB
          (br $switch (i32.const 2116753387)))
        ;; 3, 7, 11, 15 => 0xACAA49E6
        (br $switch (i32.const 2896841190))))
    ;; symbol = (word >> ((3 - index / 4) << 3)) & 0xFF
    ;; index ==  0, 4, 8, 12 => word   = 0x7AB03B10
    ;; index ==  0           => symbol = (word >> 24) & 0xFF = 0x7A
    ;; index ==  4           => symbol = (word >> 16) & 0xFF = 0xB0
    ;; index ==  8           => symbol = (word >> 8 ) & 0xFF = 0x3B
    ;; index == 12           => symbol = (word      ) & 0xFF = 0x10
    (i32.and
      (i32.shr_u
        (get_local $index_symbol_word)
        (i32.shl
          (i32.sub (i32.const 3)
            (i32.shr_u (get_local $index) (i32.const 2)))
          (i32.const 3)))
      (i32.const 255)))
  (func $check_symbol_at (param $index i32) (result i32)
    (select (i32.const 0) (i32.const 1)
      (i32.eq 
        ;; get predefined symbol for the index
        (call $compute_index_symbol (get_local $index))
        ;; iterate over user-provided sequence of 2 byte values
        (i32.load16_u (i32.shl (get_local $index) (i32.const 1))))))
  (func $encode_user_credentials
    (local $loop_indx i32)
    (set_local $loop_indx (i32.const 16))
    (block $end_of_loop (loop $shuffle_loop
      ;; from 16 downto 0 (0 - not included)
      (br_if $end_of_loop (i32.eq (get_local $loop_indx) (i32.const 0)))
      (block $switch
        (block $3
          (block $2
            (block $1
              (block $0
                ;; jump to label with index = (16 - $local_indx) / 4
                (br_table $0 $1 $2 $3
                  (i32.shr_u
                    (i32.sub (i32.const 16) (get_local $loop_indx))
                    (i32.const 2))))
              ;; 0 2 4 6 => [2 6 0 4]
              (block $switch_0
                (block $0_3
                  (block $0_2
                    (block $0_1
                      (block $0_0
                        (br_table $0_0 $0_1 $0_2 $0_3
                          (i32.and
                            (i32.sub (i32.const 16) (get_local $loop_indx))
                            (i32.const 3))))
                      ;; 0 <=> 4
                      (i32.store16 (i32.const 0)
                        (i32.xor
                          (i32.load16_u (i32.const 0))
                          (i32.load16_u (i32.const 4))))
                      (i32.store16 (i32.const 4)
                        (i32.xor
                          (i32.load16_u (i32.const 0))
                          (i32.load16_u (i32.const 4))))
                      (i32.store16 (i32.const 0)
                        (i32.xor
                          (i32.load16_u (i32.const 0))
                          (i32.load16_u (i32.const 4))))
                      (br $switch_0))
                    ;; 4 <=> 6
                    (i32.store16 (i32.const 4)
                      (i32.xor
                        (i32.load16_u (i32.const 4))
                        (i32.load16_u (i32.const 6))))
                    (i32.store16 (i32.const 6)
                      (i32.xor
                        (i32.load16_u (i32.const 4))
                        (i32.load16_u (i32.const 6))))
                    (i32.store16 (i32.const 4)
                      (i32.xor
                        (i32.load16_u (i32.const 4))
                        (i32.load16_u (i32.const 6))))
                    (br $switch_0))
                  ;; 2 <=> 6
                  (i32.store16 (i32.const 2)
                    (i32.xor
                      (i32.load16_u (i32.const 2))
                      (i32.load16_u (i32.const 6))))
                  (i32.store16 (i32.const 6)
                    (i32.xor
                      (i32.load16_u (i32.const 2))
                      (i32.load16_u (i32.const 6))))
                  (i32.store16 (i32.const 2)
                    (i32.xor
                      (i32.load16_u (i32.const 2))
                      (i32.load16_u (i32.const 6))))
                  (br $switch_0))
                ;; (dummy store operation, not in use)
                (i32.store16 (i32.const 32)
                  (i32.xor
                    (i32.load16_u (i32.const 2))
                    (i32.load16_u (i32.const 4))))
                ;; (dummy store operation, not in use)
                (i32.store16 (i32.const 34)
                  (i32.xor
                    (i32.load16_u (i32.const 2))
                    (i32.load16_u (i32.const 6))))
                ;; xor-encode user input; offset 0 xor-key 75
                (i32.store16 (i32.const 0)
                  (i32.xor
                    (i32.load16_u (i32.const 0))
                    (i32.const 75)))
                ;; xor-encode user input; offset 6 xor-key 155
                (i32.store16 (i32.const 6)
                  (i32.xor
                    (i32.load16_u (i32.const 6))
                    (i32.const 155)))
                ;; xor-encode user input; offset 4 xor-key 60
                (i32.store16 (i32.const 4)
                  (i32.xor
                    (i32.load16_u (i32.const 4))
                    (i32.const 60)))
                ;; xor-encode user input; offset 2 xor-key 251
                (i32.store16 (i32.const 2)
                  (i32.xor
                    (i32.load16_u (i32.const 2))
                    (i32.const 251)))
                ;; (dummy store operation, not in use)
                (i32.store16 (i32.const 36)
                  (i32.xor
                    (i32.load16_u (i32.const 0))
                    (i32.load16_u (i32.const 2))))
                ;; (dummy store operation, not in use)
                (i32.store16 (i32.const 38)
                  (i32.xor
                    (i32.load16_u (i32.const 0))
                    (i32.load16_u (i32.const 6))))
                (br $switch_0))
              (br $switch))
            ;; 8 10 12 14 => [10 8 12 14]
            (block $switch_1
              (block $1_3
                (block $1_2
                  (block $1_1
                    (block $1_0
                      (br_table $1_0 $1_1 $1_2 $1_3
                        (i32.and
                          (i32.sub (i32.const 16) (get_local $loop_indx))
                          (i32.const 3))))
                    ;; 8 <=> 10
                    (i32.store16 (i32.const 8)
                      (i32.xor
                        (i32.load16_u (i32.const 8))
                        (i32.load16_u (i32.const 10))))
                    (i32.store16 (i32.const 10)
                      (i32.xor
                        (i32.load16_u (i32.const 8))
                        (i32.load16_u (i32.const 10))))
                    (i32.store16 (i32.const 8)
                      (i32.xor
                        (i32.load16_u (i32.const 8))
                        (i32.load16_u (i32.const 10))))
                    (br $switch_1))
                  ;; (dummy store operation, not in use)
                  (i32.store16 (i32.const 42)
                    (i32.xor
                      (i32.load16_u (i32.const 10))
                      (i32.load16_u (i32.const 12))))
                  ;; xor-encode user input; offset 10 xor-key 253
                  (i32.store16 (i32.const 10)
                    (i32.xor
                      (i32.load16_u (i32.const 10))
                      (i32.const 253)))
                  (br $switch_1))
                ;; (dummy store operation, not in use)
                (i32.store16 (i32.const 44)
                  (i32.xor
                    (i32.load16_u (i32.const 10))
                    (i32.load16_u (i32.const 14))))
                ;; xor-encode user input; offset 12 xor-key 104
                (i32.store16 (i32.const 12)
                  (i32.xor
                    (i32.load16_u (i32.const 12))
                    (i32.const 104)))
                (br $switch_1))
              ;; xor-encode user input; offset 8 xor-key 129
              (i32.store16 (i32.const 8)
                (i32.xor
                  (i32.load16_u (i32.const 8))
                  (i32.const 129)))
              ;; (dummy store operation, not in use)
              (i32.store16 (i32.const 46)
                (i32.xor
                  (i32.load16_u (i32.const 8))
                  (i32.load16_u (i32.const 14))))
              ;; xor-encode user input; offset 14 xor-key 238
              (i32.store16 (i32.const 14)
                (i32.xor
                  (i32.load16_u (i32.const 14))
                  (i32.const 238)))
              (br $switch_1))
            (br $switch))
          ;; 16 18 20 22 => [16 22 18 20]
          (block $switch_2
            (block $2_3
              (block $2_2
                (block $2_1
                  (block $2_0
                    (br_table $2_0 $2_1 $2_2 $2_3
                      (i32.and
                        (i32.sub (i32.const 16) (get_local $loop_indx))
                        (i32.const 3))))
                  ;; (dummy store operation, not in use)
                  (i32.store16 (i32.const 48)
                    (i32.xor
                      (i32.load16_u (i32.const 16))
                      (i32.load16_u (i32.const 20))))
                  (br $switch_2))
                ;; 18 <=> 22
                (i32.store16 (i32.const 18)
                  (i32.xor
                    (i32.load16_u (i32.const 18))
                    (i32.load16_u (i32.const 22))))
                (i32.store16 (i32.const 22)
                  (i32.xor
                    (i32.load16_u (i32.const 18))
                    (i32.load16_u (i32.const 22))))
                (i32.store16 (i32.const 18)
                  (i32.xor
                    (i32.load16_u (i32.const 18))
                    (i32.load16_u (i32.const 22))))
                (br $switch_2))
              ;; 20 <=> 22
              (i32.store16 (i32.const 20)
                (i32.xor
                  (i32.load16_u (i32.const 20))
                  (i32.load16_u (i32.const 22))))
              (i32.store16 (i32.const 22)
                (i32.xor
                  (i32.load16_u (i32.const 20))
                  (i32.load16_u (i32.const 22))))
              (i32.store16 (i32.const 20)
                (i32.xor
                  (i32.load16_u (i32.const 20))
                  (i32.load16_u (i32.const 22))))
              (br $switch_2))
            ;; (dummy store operation, not in use)
            (i32.store16 (i32.const 50)
              (i32.xor
                (i32.load16_u (i32.const 18))
                (i32.load16_u (i32.const 20))))
            ;; xor-encode user input; offset 16 xor-key 121
            (i32.store16 (i32.const 16)
              (i32.xor
                (i32.load16_u (i32.const 16))
                (i32.const 121)))
            ;; xor-encode user input; offset 20 xor-key 84
            (i32.store16 (i32.const 20)
              (i32.xor
                (i32.load16_u (i32.const 20))
                (i32.const 84)))
            ;; (dummy store operation, not in use)
            (i32.store16 (i32.const 52)
              (i32.xor
                (i32.load16_u (i32.const 18))
                (i32.load16_u (i32.const 22))))
            ;; xor-encode user input; offset 22 xor-key 121
            (i32.store16 (i32.const 22)
              (i32.xor
                (i32.load16_u (i32.const 22))
                (i32.const 121)))
            ;; (dummy store operation, not in use)
            (i32.store16 (i32.const 54)
              (i32.xor
                (i32.load16_u (i32.const 20))
                (i32.load16_u (i32.const 22))))
            ;; xor-encode user input; offset 18 xor-key 173
            (i32.store16 (i32.const 18)
              (i32.xor
                (i32.load16_u (i32.const 18))
                (i32.const 173)))
            (br $switch_2))
          (br $switch))
        ;; 24 26 28 30 => [26 28 24 30]
        (block $switch_3
          (block $3_3
            (block $3_2
              (block $3_1
                (block $3_0
                  (br_table $3_0 $3_1 $3_2 $3_3
                    (i32.and
                      (i32.sub (i32.const 16) (get_local $loop_indx))
                      (i32.const 3))))
                ;; 24 <=> 26
                (i32.store16 (i32.const 24)
                  (i32.xor
                    (i32.load16_u (i32.const 24))
                    (i32.load16_u (i32.const 26))))
                (i32.store16 (i32.const 26)
                  (i32.xor
                    (i32.load16_u (i32.const 24))
                    (i32.load16_u (i32.const 26))))
                (i32.store16 (i32.const 24)
                  (i32.xor
                    (i32.load16_u (i32.const 24))
                    (i32.load16_u (i32.const 26))))
                (br $switch_3))
              ;; 26 <=> 28
              (i32.store16 (i32.const 26)
                (i32.xor
                  (i32.load16_u (i32.const 26))
                  (i32.load16_u (i32.const 28))))
              (i32.store16 (i32.const 28)
                (i32.xor
                  (i32.load16_u (i32.const 26))
                  (i32.load16_u (i32.const 28))))
              (i32.store16 (i32.const 26)
                (i32.xor
                  (i32.load16_u (i32.const 26))
                  (i32.load16_u (i32.const 28))))
              (br $switch_3))
            ;; (dummy store operation, not in use)
            (i32.store16 (i32.const 58)
              (i32.xor
                (i32.load16_u (i32.const 24))
                (i32.load16_u (i32.const 28))))
            ;; xor-encode user input; offset 30 xor-key 214
            (i32.store16 (i32.const 30)
              (i32.xor
                (i32.load16_u (i32.const 30))
                (i32.const 214)))
            ;; (dummy store operation, not in use)
            (i32.store16 (i32.const 56)
              (i32.xor
                (i32.load16_u (i32.const 24))
                (i32.load16_u (i32.const 26))))
            ;; xor-encode user input; offset 24 xor-key 38
            (i32.store16 (i32.const 24)
              (i32.xor
                (i32.load16_u (i32.const 24))
                (i32.const 38)))
            (br $switch_3))
          ;; xor-encode user input; offset 26 xor-key 145
          (i32.store16 (i32.const 26)
            (i32.xor
              (i32.load16_u (i32.const 26))
              (i32.const 145)))
          ;; (dummy store operation, not in use)
          (i32.store16 (i32.const 60)
            (i32.xor
              (i32.load16_u (i32.const 28))
              (i32.load16_u (i32.const 30))))
          ;; (dummy store operation, not in use)
          (i32.store16 (i32.const 62)
            (i32.xor
              (i32.load16_u (i32.const 26))
              (i32.load16_u (i32.const 30))))
          ;; xor-encode user input; offset 28 xor-key 168
          (i32.store16 (i32.const 28)
            (i32.xor
              (i32.load16_u (i32.const 28))
              (i32.const 168)))
          (br $switch_3))
        (br $switch))
      (set_local $loop_indx (i32.sub (get_local $loop_indx) (i32.const 1)))
      (br $shuffle_loop))))
  (func $authenticate (param $len i32) (result i32)
    (local $loop_indx i32)
    (local $correct_symbols i32)
    (local $is_authenticated i32)
    (set_local $loop_indx (i32.const 0))
    (set_local $correct_symbols (i32.const 0))
    (set_local $is_authenticated (i32.const 0))
    (if (i32.eq (get_local $len) (i32.const 16))
      (then
        ;; shuffle and xor-encode user credentials
        (call $encode_user_credentials)
        ;; loop for each symbol in user credentials
        (block $end_of_loop (loop $check_credentials_loop
          (br_if $end_of_loop (i32.eq (get_local $loop_indx) (get_local $len)))
          ;; accumulate the number of correct symbols
          (set_local $correct_symbols (i32.add (get_local $correct_symbols)
            (block $switch (result i32)
              (block $wrong
                (block $correct
                  ;; call checker, switch on result: 0 - correct, 1 - wrong
                  (br_table $correct $wrong (call $check_symbol_at (get_local $loop_indx))))
                ;; current symbol is correct
                (br $switch (i32.const 1)))
              ;; current symbol is wrong
              (br $switch (i32.const 0)))))
          (set_local $loop_indx (i32.add (get_local $loop_indx) (i32.const 1)))
          (br $check_credentials_loop)))
        (set_local $is_authenticated
          (select (i32.const 1) (i32.const 0)
            (i32.eq (get_local $correct_symbols) (i32.const 16))))))
    (get_local $is_authenticated))
  (export "authenticate" (func $authenticate)))
