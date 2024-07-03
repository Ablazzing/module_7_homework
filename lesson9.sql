--drop table words_stat;
create table words_stat (id bigserial primary key, word varchar(100), count_search bigint);

create procedure add_words(count_words int) 
language plpgsql
as $$
declare i int;
	begin
		foreach i in ARRAY(select ARRAY(select * from generate_series(1, count_words)))
		loop
			insert into words_stat (word, count_search) values( concat('word', i), i);
		end loop;
	end;
$$;

create procedure add_words_with_count(count_words int) 
language plpgsql
as $$
declare i int;
declare count_rows int = (select count(*) from words_stat);
	begin
		foreach i in ARRAY(select ARRAY(select * from generate_series(1, count_words)))
		loop
			insert into words_stat (word, count_search) values( concat('word', i + count_rows), i + count_rows);
		end loop;
	end;
$$;

--9sec
call add_words(1000000);

--
call add_words_with_count(1000000);

create index word_index_idx on words_stat(word);
drop index word_index_idx;

select *
from words_stat
where word = 'word100072'

select *
from words_stat
where id = 200073




