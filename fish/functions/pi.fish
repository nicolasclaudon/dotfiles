function pi --description 'pi avec la clé Mistral depuis 1Password'
    MISTRAL_API_KEY=(op read 'op://Private/Mistral API/identifiant') command pi $argv
end
