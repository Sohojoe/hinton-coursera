function write(word1, word2, word3, model, k)
% Writes for k words based on the 3 propts.
% Inputs:
%   word1: The first word as a string.
%   word2: The second word as a string.
%   word3: The third word as a string.
%   model: Model returned by the training script.
%   k: The k most probable predictions are shown.
% Example usage:
%   predict_next_word('john', 'might', 'be', model, 3);
%   predict_next_word('life', 'in', 'new', model, 3);

word_embedding_weights = model.word_embedding_weights;
vocab = model.vocab;
id1 = strmatch(word1, vocab, 'exact');
id2 = strmatch(word2, vocab, 'exact');
id3 = strmatch(word3, vocab, 'exact');

skipSpace = {'.' '?' ',' ':' '-' ')' '--' 'nt' '''s'};
nt = 'nt';
newSentance = {'.' '?'};
notNewSentance = [skipSpace, newSentance];

if ~any(id1)
  fprintf(1, 'Word ''%s\'' not in vocabulary.\n', word1);
  return;
end
if ~any(id2)
  fprintf(1, 'Word ''%s\'' not in vocabulary.\n', word2);
  return;
end
if ~any(id3)
  fprintf(1, 'Word ''%s\'' not in vocabulary.\n', word3);
  return;
end
fprintf(1, '%s %s %s', word1, word2, word3);
word0 = '';
nextWord = '';
newLine = false;
for i = 1:k
    input = [id1; id2; id3];
    words = {word0, word1 word2 word3};
    skipNewSentance = sum(ismember(words,newSentance));
    nextWord = '';
    while (strcmp(nextWord, ''))
        [embedding_layer_state, hidden_layer_state, output_layer_state] = ...
            fprop(input, model.word_embedding_weights, model.embed_to_hid_weights,...
            model.hid_to_output_weights, model.hid_bias, model.output_bias);
        [prob, indices] = sort(output_layer_state, 'descend');
        rEnd = rand()^4;
        r = 0;
        for n = 1:length(prob)
            id3 = indices(n);
            nextWord = vocab{indices(n)};
            r = r + prob(n);
            if (r >= rEnd)
                break;
            end
        end
        if (skipNewSentance)
            if (any(strmatch(nextWord,notNewSentance, 'exact')))
                nextWord = '';
            end
        end
    end

    words = {word1 word2 word3, nextWord};

    id1 = id2;
    id2 = id3;
    word0 = word1;
    word1 = word2;
    word2 = word3;
    word3 = nextWord;
    
    if (~any(strmatch(nextWord,skipSpace, 'exact')))
       fprintf(1, ' ' ); 
    end
    if (strcmp(nextWord,nt))
       nextWord = 'n''t';
    end
   fprintf(1, '%s' ,nextWord); 
   
   if (any(strmatch(nextWord,newSentance, 'exact')))
       newLine = true;
%    if (false)
       while (any(strmatch(nextWord,notNewSentance, 'exact')))
           n = randi(length(prob));
           id3 = indices(n);
           nextWord = vocab{indices(n)};
       end
    id1 = id2;
    id2 = id3;
    word0 = word1;
    word1 = word2;
    word2 = word3;
    word3 = nextWord;
%     if (~any(strmatch(nextWord,skipSpace, 'exact')))
%        fprintf(1, ' ' ); 
%     end
    fprintf(1, '\n' ); 
    newLine = false;
    if (strcmp(nextWord,nt))
       nextWord = 'n''t';
    end
   fprintf(1, '%s' ,nextWord); 
   end
end
fprintf(1, '\n' ); 
