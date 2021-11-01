function extracted_fp = extract_fp(R,MR,secretKey,sensitivity,epsilon1)



K = floor(log2(sensitivity))+1;

p = 1/( exp(epsilon1/K)+1 );


bits_required =  floor( log2( max( MR.Variables,[],1) ) )+1;
bits_required = bits_required(2:end);




[row_num,col_num] = size(MR);

L = 128;

fp_count0 = zeros(1,L);

fp_count1 = zeros(1,L);

T = col_num-1;

Dic_key_range = row_num*K*T; % attribute number  = col_num-1




for i  = 1:row_num
    
    if mod(i,100)==0
        i
    end
    primary_key_att_value = MR{i,1};
    for t = 1:T
        bit_length = bits_required(t);
        
        k_min = min(bit_length,K);
        
        r_it = R{i,t+1}; % skip the first column of index, i.e., primary key
        r_it_binary =    dec2bin(r_it);
        temp = int2str( zeros( 1, k_min-length(r_it_binary)  ) );
        temp = temp(find(~isspace(temp)));
        r_it_binary = [  temp   r_it_binary]; % zero padding
        
        mr_it = MR{i,t+1}; % skip the first column of index, i.e., primary key
        mr_it_binary =    dec2bin(mr_it);
        temp2 = int2str( zeros( 1, k_min-length(mr_it_binary)  ) ) ;
        temp2 = temp2(find(~isspace(temp2)));
        mr_it_binary = [temp2     mr_it_binary]; % zero padding
        
        
        for k = 1:k_min
            %             [i t k]
            seed = [double(secretKey)  primary_key_att_value t k];
            rng(sum(seed));
            rnd_seq = datasample([1:Dic_key_range],3,'Replace',false);
            %             if ~mod(rnd_seq(1),floor( 1/(2*p) ) )
            if rand<2*p
                
                
                B = xor(  str2num( r_it_binary(end-k+1)),  str2num (mr_it_binary(end-k+1))  );
                
                
                
                x = mod(  rnd_seq(2),2 );
                
                f = xor (x,B);
                
                l = mod(rnd_seq(3),L)+1;
                
                if f ==0
                    fp_count0(l) = fp_count0(l)+1;
                else
                    fp_count1(l) = fp_count1(l)+1;
                end
            end
        end
        %         i
    end
end
    
    
extracted_fp = fp_count1>=fp_count0;
    
    
end